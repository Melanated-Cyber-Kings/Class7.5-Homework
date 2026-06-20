# ---------------------------------------------------------------------------
# site-b-vpn.tf
# Site B's HA VPN gateway and its two tunnels back to Site A. Each tunnel
# here is the "other end" of a pair started in site-a-vpn.tf.
# ---------------------------------------------------------------------------

resource "google_compute_ha_vpn_gateway" "ha_gateway2" {
  region  = "us-central1"
  name    = "ha-vpn-2"
  network = google_compute_network.network2.id
}

# Other end of the tunnel1 <-> tunnel3 pair (interface 0 to interface 0).
resource "google_compute_vpn_tunnel" "tunnel3" {
  name                  = "ha-vpn-tunnel3"
  region                = "us-central1"
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway2.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway1.id
  shared_secret         = "a secret message" # must match tunnel1's secret
  router                = google_compute_router.router2.id
  vpn_gateway_interface = 0
}

# Other end of the tunnel2 <-> tunnel4 pair (interface 1 to interface 1).
resource "google_compute_vpn_tunnel" "tunnel4" {
  name                  = "ha-vpn-tunnel4"
  region                = "us-central1"
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway2.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway1.id
  shared_secret         = "a secret message" # must match tunnel2's secret
  router                = google_compute_router.router2.id
  vpn_gateway_interface = 1
}