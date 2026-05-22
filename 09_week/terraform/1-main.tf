resource "google_compute_network" "top-network" {
  name                    = "thomasbell-network"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "top-sub-network" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.top-network.self_link
}

# Firewall HTTP
resource "google_compute_firewall" "http" {
  name    = "${var.vpc_name}-http"
  network = google_compute_network.top-network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http"]
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}

# startup script 
locals {
  startup_script = file("${path.module}/startup.sh")
}

# Instance Template
resource "google_compute_instance_template" "basic-template" {
  name_prefix = "basic-template"

  machine_type = var.machine_type
  tags         = ["http"]

  disk {
    source_image = "centos-cloud/centos-stream-10"
    auto_delete  = true
    boot         = true
    disk_size_gb = var.boot_disk_size_gb
  }

  network_interface {
    network    = google_compute_network.top-network.self_link
    subnetwork = google_compute_subnetwork.top-sub-network.self_link

    access_config {}
  }

  metadata = {
    student_name = var.student_name
  }

  metadata_startup_script = local.startup_script
}

# MIG
resource "google_compute_instance_group_manager" "mig" {
  name               = "mig"
  base_instance_name = "seir1"
  zone               = var.zone

  target_size = var.mig_target_size

  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template = google_compute_instance_template.basic-template.self_link
  }


  auto_healing_policies {
    health_check      = google_compute_health_check.health-check.self_link
    initial_delay_sec = 300

  }
}

# Autoscaler
resource "google_compute_autoscaler" "autoscaler" {
  name   = "autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.mig.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}

# Health check
resource "google_compute_health_check" "health-check" {
  name                = "health-check"
  check_interval_sec  = 30
  timeout_sec         = 10
  healthy_threshold   = 3
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/"
  }
}