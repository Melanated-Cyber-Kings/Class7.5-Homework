# Backend Health Check
resource "google_compute_http_health_check" "backend_doctor" {
  name               = "backend-doctor"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

# Backend
resource "google_compute_backend_service" "web" {
  name                  = "web-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_http_health_check.backend_doctor.self_link]

  backend {
    group = google_compute_region_instance_group_manager.webserver.instance_group
  }
}