# LB
resource "google_compute_global_address" "web_lb_ip" {
  name = "web-lb-ip"
}

#URL Map
resource "google_compute_url_map" "web_url_map" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.web.id
}

resource "google_compute_target_http_proxy" "web_proxy" {
  name    = "web-proxy"
  url_map = google_compute_url_map.web_url_map.id
}

resource "google_compute_global_forwarding_rule" "web_forward_rule" {
  name                  = "ssl-proxy-xlb-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.web_proxy.id
  ip_address            = google_compute_global_address.web_lb_ip.address
}
