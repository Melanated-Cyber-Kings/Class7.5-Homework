resource "google_compute_network" "vpc_network" {
  name                    = "${var.project-name}-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "subnetworks" {
  name          = "${var.project-name}-subnetwork"
  ip_cidr_range = "10.0.35.0/24"
  region        = local.region
  network       = google_compute_network.vpc_network.id
}