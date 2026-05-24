resource "google_compute_health_check" "week10_lb" {
  name                = "week10-lb"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port         = 80
    request_path = "/healthz"
  }
}

resource "google_compute_backend_service" "week10app" {
  name                  = "backend"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL_MANAGED" # Global Application LB (Envoy-based)
  timeout_sec           = 30

  health_checks = [google_compute_health_check.week10_lb.id]

  backend {
    group           = google_compute_region_instance_group_manager.week10.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  # Session affinity is NONE — instances are stateless.
  # Change to CLIENT_IP or GENERATED_COOKIE if your app requires stickiness.
  session_affinity = "NONE"
}