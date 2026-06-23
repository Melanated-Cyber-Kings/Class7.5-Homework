resource "google_compute_backend_service" "web" {
  name                  = "web-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.web_health.id]

  backend {
    group = google_compute_region_instance_group_manager.web_regional_mig.instance_group
  }
}










# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service