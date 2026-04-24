resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-rule"
  network = "default" # Or your custom VPC name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Allow traffic from any source
  source_ranges = ["0.0.0.0/0"]

  # Only apply this rule to VMs with the "http-server" tag
  target_tags = ["http-server"]
}