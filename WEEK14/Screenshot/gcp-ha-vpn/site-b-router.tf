# ---------------------------------------------------------------------------
# site-b-router.tf
# Cloud Router for Site B — runs the BGP sessions that mirror Site A's.
# ---------------------------------------------------------------------------

# ASN 64515 — must be DIFFERENT from Site A's 64514. Two routers peering
# over BGP can't share an ASN (that would imply they're the same
# autonomous system, which breaks BGP's loop-prevention logic).
resource "google_compute_router" "router2" {
  name    = "ha-vpn-router2"
  region  = "us-central1"
  network = google_compute_network.network2.name
  bgp {
    asn = 64515
  }
}

# Pairs with router1_interface1 — note the addresses are flipped (.2 here
# vs .1 on Site A) within the same 169.254.0.0/30 link-local subnet.
resource "google_compute_router_interface" "router2_interface1" {
  name       = "router2-interface1"
  router     = google_compute_router.router2.name
  region     = "us-central1"
  ip_range   = "169.254.0.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel3.name
}

resource "google_compute_router_peer" "router2_peer1" {
  name                      = "router2-peer1"
  router                    = google_compute_router.router2.name
  region                    = "us-central1"
  peer_ip_address           = "169.254.0.1" # Site A's interface1 address
  peer_asn                  = 64514         # Site A's router ASN
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router2_interface1.name
}

# Pairs with router1_interface2, using the second link-local /30
# (169.254.1.0/30).
resource "google_compute_router_interface" "router2_interface2" {
  name       = "router2-interface2"
  router     = google_compute_router.router2.name
  region     = "us-central1"
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel4.name
}

resource "google_compute_router_peer" "router2_peer2" {
  name                      = "router2-peer2"
  router                    = google_compute_router.router2.name
  region                    = "us-central1"
  peer_ip_address           = "169.254.1.2" # Site A's interface2 address
  peer_asn                  = 64514
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router2_interface2.name
}