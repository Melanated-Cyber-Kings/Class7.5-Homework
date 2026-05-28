resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.week9.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}
# The allows HTTP traffic from anywhere to VMs with the tag "http-server"


resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.week9.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
# No target tags. for all VMs in the network


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall