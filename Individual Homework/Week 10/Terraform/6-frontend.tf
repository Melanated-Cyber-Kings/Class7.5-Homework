
resource "google_compute_global_address" "app" {
  name        = "global-app-ip"
  description = "Static external IP for the global HTTP load balancer."
}


resource "google_compute_url_map" "app" {
  name        = "week10-lb"
  description = "URL map for app."

  default_service = google_compute_backend_service.week10app.id

}


resource "google_compute_target_http_proxy" "app" {
  name    = "test-proxy"
  url_map = google_compute_url_map.app.id
}

resource "google_compute_global_forwarding_rule" "app" {
  name                  = "forwarding-rule"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_http_proxy.app.id
  ip_address            = google_compute_global_address.app.address
  ip_protocol           = "TCP"
  port_range            = "80"


}

