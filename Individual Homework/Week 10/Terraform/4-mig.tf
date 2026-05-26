resource "google_compute_health_check" "week10app" {
  name                = "${var.app_name}-hc-mig"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port         = 80
    request_path = "/healthz"
  }
}

resource "google_compute_region_instance_group_manager" "week10" {
  name               = "${var.app_name}-igm"
  base_instance_name = "web"
  region             = var.region
  distribution_policy_zones = [
    "us-central1-a",
    "us-central1-b",
    "us-central1-c",
  "us-central1-f"]
  target_size = 4

  version {
    instance_template = google_compute_instance_template.week10supera.id
  }

  named_port {
    name = "http"
    port = 80
  }
  auto_healing_policies {
    health_check      = google_compute_health_check.week10app.id
    initial_delay_sec = 300
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager#distribution_policy_target_shape-1



