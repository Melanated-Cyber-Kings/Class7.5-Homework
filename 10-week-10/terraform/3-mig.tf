# Create a regional managed instance group for high availability
resource "google_compute_region_instance_group_manager" "web_regional_mig" {
  name               = "web-server-regional-mig"
  base_instance_name = "web-regional"
  # target_size = 4 # don't need this if you are autoscaling

  # Distribute instances across these zones
  distribution_policy_zones = [
    "us-central1-a",
    "us-central1-b",
    "us-central1-c",
    "us-central1-f"
  ]

  # Even distribution across zones
  distribution_policy_target_shape = "EVEN"

  version {
    instance_template = google_compute_instance_template.supera.id
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.web_health.id
    initial_delay_sec = 300
  }
}

# Autoscaler for the regional MIG
resource "google_compute_region_autoscaler" "web_regional_as" {
  name   = "web-regional-autoscaler"
  region = "us-central1"
  target = google_compute_region_instance_group_manager.web_regional_mig.id

  autoscaling_policy {
    min_replicas    = 4
    max_replicas    = 8
    cooldown_period = 60

    # Scale based on multiple signals
    cpu_utilization {
      target = 0.6
    }

    # Scale-in controls to prevent aggressive scale-down
    scale_in_control {
      max_scaled_in_replicas {
        fixed = 2
      }
      time_window_sec = 600
    }
  }
}

resource "google_compute_health_check" "web_health" {
  name                = "health"
  check_interval_sec  = 30
  timeout_sec         = 10
  healthy_threshold   = 3
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/healthz"
  }
}


# https://oneuptime.com/blog/post/2026-02-23-how-to-create-gcp-managed-instance-groups-with-terraform/view