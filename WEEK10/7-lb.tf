#FRONTEND
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
  default_service = google_compute_backend_service.colombia.id 

  host_rule {
    hosts        = ["*"]
    path_matcher = "lb-paths"
  }

  path_matcher {
    name            = "lb-paths"
    default_service = google_compute_backend_service.colombia.id  # fallback

    path_rule {
      paths   = ["/colombia", "/colombia/*"]
      service = google_compute_backend_service.colombia.id
    }

    path_rule {
      paths   = ["/thailand", "/thailand/*"]
      service = google_compute_backend_service.thailand.id
    }
  }
}

#BACKEND— COLOMBIA
resource "google_compute_backend_service" "colombia" {
  name                  = "colombia"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  load_balancing_scheme = "EXTERNAL"

  backend {
    group           = google_compute_instance_group_manager.colombia.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
  }

  health_checks = [google_compute_health_check.colombia_health_check.id]

  log_config {
    enable      = true
    sample_rate = 1.0
  }
}
# BACKEND — THAILAND
resource "google_compute_backend_service" "thailand" {
  name                  = "thailand"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  load_balancing_scheme = "EXTERNAL"

  backend {
    group           = google_compute_instance_group_manager.thailand.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
  }

  health_checks = [google_compute_health_check.thailand_health_check.id]

  log_config {
    enable      = true
    sample_rate = 1.0
  }
}