# HTTP Environment

# Request static IP address for the load balancer.
# Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address.html
resource "google_compute_global_address" "mephisto_lb_ip" {
  name         = "${var.lb_name}-ip"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}


# Set up global forwarding rule for the load balancer. 
# Need to set rule to forward traffic from HTTP to HTTPS 
# since the load balancer is configured to listen on port 443 for HTTPS traffic.
# Reference: https://cloud.google.com/load-balancing/docs/https#forwarding-rule

resource "google_compute_global_forwarding_rule" "mephisto_forwarding_rule_http" {
  name                  = "${var.lb_name}-forwarding-rule-http"
  target                = google_compute_target_http_proxy.mephisto_http_proxy.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_protocol           = "TCP"
  ip_address            = google_compute_global_address.mephisto_lb_ip.address
}

# HTTP proxy Target
resource "google_compute_target_http_proxy" "mephisto_http_proxy" {
  name    = "${var.lb_name}-http-proxy"
  url_map = google_compute_url_map.mephisto_url_map_redirect.self_link
}

# Redirect HTTP traffic to HTTPS.
resource "google_compute_url_map" "mephisto_url_map_redirect" {
  name = "${var.lb_name}-url-map-redirect"
  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}

# HTTPS Environment
# Set up HTTPS proxy for the load balancer.
# Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy

resource "google_compute_target_https_proxy" "mephisto_https_proxy" {
  name    = "${var.lb_name}-https-proxy"
  url_map = google_compute_url_map.mephisto_url_map.self_link

  # Use certificate map because the load balancer is an external type.

  certificate_map = "//certificatemanager.googleapis.com/${google_certificate_manager_certificate_map.mephisto_cert_map.id}"
}



resource "google_compute_global_forwarding_rule" "mephisto_forwarding_rule_https" {
  name                  = "${var.lb_name}-forwarding-rule-https"
  target                = google_compute_target_https_proxy.mephisto_https_proxy.self_link
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_protocol           = "TCP"
  ip_address            = google_compute_global_address.mephisto_lb_ip.address
}

