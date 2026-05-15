# Create Virtual Private Cloud (VPC) and Subnet
resource "google_compute_network" "mephisto" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "mephisto" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.mephisto.self_link
}

# Firewall rule to allow HTTP traffic.
resource "google_compute_firewall" "http" {
  name    = "${var.vpc_name}-allow-http"
  network = google_compute_network.mephisto.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http-server"]
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}

# Call startup script to install software on first boot. 
locals {
  startup_script = file("${path.root}/../scripts/startup.sh")
}

# Instance Template for the Managed Instance Group (MIG).
resource "google_compute_instance_template" "mephisto_template" {
  name_prefix = "mephisto-template-"

  machine_type = var.machine_type
  tags         = ["http-server"]

  disk {
    source_image = "centos-cloud/centos-stream-10"
    auto_delete  = true
    boot         = true
    disk_size_gb = var.boot_disk_size_gb
  }

  network_interface {
    network    = google_compute_network.mephisto.self_link
    subnetwork = google_compute_subnetwork.mephisto.self_link

    # Public IP for simplicity
    access_config {}
  }

  metadata = {
    student_name = var.student_name
  }

  metadata_startup_script = local.startup_script
}

# Managed Instance Group (MIG) configuration.
resource "google_compute_instance_group_manager" "mephisto_mig" {
  name               = "mephisto-mig"
  base_instance_name = "mephisto"
  zone               = var.zone

  target_size = var.mig_target_size

  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template = google_compute_instance_template.mephisto_template.self_link
  }


  auto_healing_policies {
    health_check      = google_compute_health_check.mephisto_health_check.self_link
    initial_delay_sec = 300

  }
}

# Autoscaler configuration for the MIG.
resource "google_compute_autoscaler" "mephisto_autoscaler" {
  name   = "mephisto-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.mephisto_mig.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}

# Health check configuration.
resource "google_compute_health_check" "mephisto_health_check" {
  name                = "mephisto-health-check"
  check_interval_sec  = 30
  timeout_sec         = 10
  healthy_threshold   = 3
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/"
  }
}