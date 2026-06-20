# ---------------------------------------------------------------------------
# site-a-vpn.tf
# The HA VPN gateway for Site A and the two tunnels connecting it to
# Site A's HA VPN gateway counterpart in Site B.
# ---------------------------------------------------------------------------

# An HA (High Availability) VPN gateway always gets TWO public IP
# interfaces (interface 0 and interface 1) automatically. Each interface
# gets its own tunnel below — that redundancy is what gives HA VPN its
# 99.99% SLA: if one interface/tunnel goes down, traffic fails over to
# the other.
resource "google_compute_ha_vpn_gateway" "ha_gateway1" {
  region  = "us-central1"
  name    = "ha-vpn-1"
  network = google_compute_network.network1.id
}

# Tunnel using ha_gateway1's interface 0, terminating on ha_gateway2
# (defined in site-b-vpn.tf). shared_secret is the IPsec pre-shared key —
# it MUST be byte-for-byte identical on both ends of a tunnel pair, or
# the tunnel will never come up.
resource "google_compute_vpn_tunnel" "tunnel1" {
  name                  = "ha-vpn-tunnel1"
  region                = "us-central1"
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway1.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway2.id
  shared_secret         = "a secret message" # must match tunnel3's secret (other end of this pair)
  router                = google_compute_router.router1.id
  vpn_gateway_interface = 0 # uses ha_gateway1's FIRST public IP
}

# Tunnel using ha_gateway1's interface 1 — the redundant second path.
# Pairs with tunnel4 on the Site B side.
resource "google_compute_vpn_tunnel" "tunnel2" {
  name                  = "ha-vpn-tunnel2"
  region                = "us-central1"
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway1.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway2.id
  shared_secret         = "a secret message" # must match tunnel4's secret key
  router                = google_compute_router.router1.id
  vpn_gateway_interface = 1 # uses ha_gateway1's SECOND public IP
}