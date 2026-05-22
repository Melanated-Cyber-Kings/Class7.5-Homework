resource "google_compute_firewall" "firewall" {
  name          = "${local.project}-firewall"
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["lews-tag"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}
