
resource "google_compute_global_address" "app" {
  name        = "${var.app_name}-lb-ip"
  description = "Static external IP for the global HTTP load balancer."
}


resource "google_compute_url_map" "app" {
  name        = "${var.app_name}-url-map"
  description = "URL map for ${var.app_name}."

  default_service = google_compute_backend_service.week10app.id

}


resource "google_compute_target_http_proxy" "app" {
  name    = "${var.app_name}-http-proxy"
  url_map = google_compute_url_map.app.id
}

resource "google_compute_global_forwarding_rule" "app" {
  name                  = "${var.app_name}-http-forwarding"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_http_proxy.app.id
  ip_address            = google_compute_global_address.app.address
  ip_protocol           = "TCP"
  port_range            = "80"


}

