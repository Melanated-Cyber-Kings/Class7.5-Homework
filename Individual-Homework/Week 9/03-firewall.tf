# Gained info from Udemy https://www.udemy.com/course/terraform-for-beginners-using-google-cloud/learn/lecture/28659708#overview
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall

resource "google_compute_firewall" "allow_ssh" {
  name        = "week9-firewall-rule-shh"
  network     = google_compute_network.week9hw.id
  description = "Creates firewall rule targeting SSH tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["foo"]
  target_tags = ["web"]
}

resource "google_compute_firewall" "allow_http" {
  name        = "week9-firewall-rule-http"
  network     = google_compute_network.week9hw.id
  description = "Creates firewall rule targeting HTTP tagged instances"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["foo"]
  target_tags = ["web"]
}
