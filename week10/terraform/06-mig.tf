resource "google_compute_region_instance_group_manager" "mig" {
  name                      = "${var.project-name}-mig"
  base_instance_name        = "lew"
  region                    = local.region
  distribution_policy_zones = ["us-central1-a", "us-central1-b", "us-central1-c"]

  version {
    instance_template = google_compute_instance_template.class_template.id
  }

  target_size = 3

  auto_healing_policies {
    health_check      = google_compute_region_health_check.autohealing.id
    initial_delay_sec = 300
  }

  named_port {
    name = "http"
    port = 80
  }
}