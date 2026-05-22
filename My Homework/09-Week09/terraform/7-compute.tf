locals {
  startup_script = file("${path.root}/../scripts/startup.sh")
}

resource "google_compute_instance" "vm" {
  name         = "lab-vm"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-stream-10"
      size  = 100
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private.id

    # External IP for SSH (lab simplicity)
    access_config {}
  }
# Call startup script to install software on first boot. 

  metadata_startup_script = local.startup_script

  tags = ["ssh", "http", "http-server"]

  depends_on = [
    google_compute_subnetwork.private,
    google_compute_router_nat.nat
  ]
}

# Managed Instance Group (MIG) configuration.
resource "google_compute_instance_group_manager" "first_mig" {
  name               = "first-mig"
  base_instance_name = "first"
  zone               = var.zone

  target_size = var.mig_target_size

  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template = google_compute_instance_template.first_template.self_link
  }


  auto_healing_policies {
    health_check      = google_compute_health_check.first_health_check.self_link
    initial_delay_sec = 300

  }
}

# Autoscaler configuration for the MIG.
resource "google_compute_autoscaler" "first_autoscaler" {
  name   = "first-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.first_mig.id

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
resource "google_compute_health_check" "first_health_check" {
  name                = "first-health-check"
  check_interval_sec  = 30
  timeout_sec         = 10
  healthy_threshold   = 3
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/"
  }
}