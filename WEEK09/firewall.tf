resource "google_compute_firewall" "lb_firewall" {
  name    = "lb-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = [
    "0.0.0.0/0",       # Allow all internet traffic on port 80
    "130.211.0.0/22",  # GCP health checker 
    "35.191.0.0/16"    # GCP health checker
  ]

  # Allow SSH from anywhere so we can connect to VMs for debugging if needed
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

}