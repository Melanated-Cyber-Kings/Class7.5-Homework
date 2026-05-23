
# Instance Template
resource "google_compute_region_instance_template" "basic_gui" {
  name_prefix  = "basic-gui"
  machine_type = var.machine_type
  tags         = ["http"]

  disk {
    source_image = "debian-cloud/debian-12-bookworm-v20260513"
    auto_delete  = true
    boot         = true
    disk_size_gb = var.boot_disk_size_gb
  }

  network_interface {
    subnetwork = google_compute_subnetwork.zerocore.self_link

    access_config {
      # This allows you to assign a public, external IP to a virtual machine.
    }
  }

  metadata_startup_script = file("./startup.sh")
}

# Health check comes before MIG
resource "google_compute_health_check" "weightloss" {
  name                = "health-check"
  check_interval_sec  = 30
  timeout_sec         = 10
  healthy_threshold   = 3
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/healthz"
  }
}

# MIG
resource "google_compute_region_instance_group_manager" "webserver" {
  name               = "webserver-mig"
  base_instance_name = "seir1"

  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template = google_compute_region_instance_template.basic_gui.self_link
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.weightloss.self_link
    initial_delay_sec = 300
  }
}

# Autoscaler
resource "google_compute_region_autoscaler" "planar" {
  name   = "planar"
  target = google_compute_region_instance_group_manager.webserver.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}
