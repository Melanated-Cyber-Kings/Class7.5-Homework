# MIG
resource "google_compute_region_instance_group_manager" "apps" {
  name = "apps"

  base_instance_name        = "app"
  region                    = "us-central1"
  distribution_policy_zones = ["us-central1-a", "us-central1-b", "us-central1-c", "us-central1-f"]
  target_size               = 3

  version {
    instance_template = google_compute_region_instance_template.beef.id
  }



  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.doctor.id
    initial_delay_sec = 300
  }
}