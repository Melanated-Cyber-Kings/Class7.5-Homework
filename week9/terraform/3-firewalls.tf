# Resource used to create firewall rules with target tags 👉 https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall.html

resource "google_compute_firewall" "rules" {
  project     = "class75sier1"
  name        = "week9hw-firewall-rule"
  network     = google_compute_network.week9hw-vpc.name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }

  source_tags = ["foo"]
  target_tags = ["web"]
}