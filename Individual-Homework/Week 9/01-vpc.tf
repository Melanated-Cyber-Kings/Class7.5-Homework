# VPC code block from Hasicorp Site https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network.html
resource "google_compute_network" "week9hw" {
  project                 = "cloud2026-490221"
  name                    = "week9hw"
  auto_create_subnetworks = false
  mtu                     = 1460
}