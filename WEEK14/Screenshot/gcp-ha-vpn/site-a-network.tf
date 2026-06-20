# ---------------------------------------------------------------------------
# site-a-network.tf
# The VPC network and subnetworks for Site A. Everything else for Site A
# (gateway, tunnels, router) attaches to this network.
# ---------------------------------------------------------------------------

# A custom-mode VPC (no auto-created subnets) so we control the IP ranges
# ourselves. routing_mode = "GLOBAL" lets the Cloud Router advertise/learn
# routes for subnets in ANY region, not just the router's own region —
# important here since network1 has subnets in two different regions.
resource "google_compute_network" "network1" {
  name                    = "network1"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

# Primary subnet for Site A, in us-central1 — same region as the VPN
# gateway and Cloud Router below.
resource "google_compute_subnetwork" "network1_subnet1" {
  name          = "ha-vpn-subnet-1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.network1.id
}

# Second subnet for Site A, in a DIFFERENT region (us-west1). This is
# what actually exercises GLOBAL routing mode above: this subnet's region
# doesn't match the router's region, but it still needs to be reachable
# over the VPN.
resource "google_compute_subnetwork" "network1_subnet2" {
  name          = "ha-vpn-subnet-2"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-west1"
  network       = google_compute_network.network1.id
}