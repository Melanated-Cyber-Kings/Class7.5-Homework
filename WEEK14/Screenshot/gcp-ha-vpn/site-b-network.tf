# ---------------------------------------------------------------------------
# site-b-network.tf
# The VPC network and subnetworks for Site B — mirrors site-a-network.tf
# but with a non-overlapping IP range (192.168.0.0/16 vs Site A's
# 10.0.0.0/16). Overlapping ranges between the two sides is the #1 reason
# this kind of VPN fails to route traffic correctly, so double-check this
# whenever you change either side.
# ---------------------------------------------------------------------------

resource "google_compute_network" "network2" {
  name                    = "network2"
  routing_mode            = "GLOBAL" # same reasoning as network1: subnets span regions
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "network2_subnet1" {
  name          = "ha-vpn-subnet-3"
  ip_cidr_range = "192.168.1.0/24"
  region        = "us-central1" # same region as router2/ha_gateway2
  network       = google_compute_network.network2.id
}

resource "google_compute_subnetwork" "network2_subnet2" {
  name          = "ha-vpn-subnet-4"
  ip_cidr_range = "192.168.2.0/24"
  region        = "us-east1" # different region — relies on GLOBAL routing mode above
  network       = google_compute_network.network2.id
}