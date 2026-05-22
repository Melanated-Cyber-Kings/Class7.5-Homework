resource "google_compute_firewall" "lb_firewall" {
  name    = "lb-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [
    "0.0.0.0/0",       # Allow all internet traffic on port 80
    "130.211.0.0/22",  # GCP health checker
    "35.191.0.0/16"    # GCP health checker
  ]

  target_tags = ["lb-instance"]  #covers both colombia and thailand VMs
}