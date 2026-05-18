resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "subnetworks" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.0.35.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}