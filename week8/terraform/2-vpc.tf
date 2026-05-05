resource "google_compute_" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = true
}
