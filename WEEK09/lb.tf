# FRONTEND
resource "google_compute_global_forwarding_rule" "lb_frontend" {
  name                  = "lb-frontend"
  target                = google_compute_target_http_proxy.lb_http_proxy.id
  port_range            = "80"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_target_http_proxy" "lb_http_proxy" {
  name    = "lb-http-proxy"
  url_map = google_compute_url_map.lb_url_map.id
}

resource "google_compute_url_map" "lb_url_map" {
  name            = "lb-url-map"
  default_service = google_compute_backend_service.lb_backend.id
}

# BACKEND
resource "google_compute_backend_service" "lb_backend" {
  name                  = "lb-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  load_balancing_scheme = "EXTERNAL"

  backend {
    group           = google_compute_instance_group_manager.instance_group.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
  }

  # References health.tf
  health_checks = [google_compute_health_check.lb_health_check.id]
  log_config {
    enable      = true
    sample_rate = 1.0  # Log 100% of requests
  }
}