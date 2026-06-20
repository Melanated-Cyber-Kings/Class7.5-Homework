# ---------------------------------------------------------------------------
# site-a-router.tf
# The Cloud Router for Site A. Cloud Router runs the BGP sessions that
# dynamically exchange subnet routes with Site B over the two tunnels, so
# neither side needs hardcoded static routes.
# ---------------------------------------------------------------------------

# asn = this router's own BGP Autonomous System Number. 64514 is in the
# private ASN range (64512–65534), which is what you use for GCP-to-GCP
# or GCP-to-on-prem links that aren't exposed on the public internet.
resource "google_compute_router" "router1" {
  name    = "ha-vpn-router1"
  region  = "us-central1"
  network = google_compute_network.network1.name
  bgp {
    asn = 64514
  }
}

# Router-side interface for tunnel1. ip_range is a /30 (4 usable-ish IPs)
# out of the reserved link-local block 169.254.0.0/16 — used ONLY for
# the BGP session itself, never for real workload traffic. ".1" is this
# router's address in the pair; the peer below takes ".2".
resource "google_compute_router_interface" "router1_interface1" {
  name       = "router1-interface1"
  router     = google_compute_router.router1.name
  region     = "us-central1"
  ip_range   = "169.254.0.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel1.name
}

# BGP peer config for the interface above. peer_ip_address (.2) must be
# the OTHER end's interface IP, and peer_asn (64515) must match Site B's
# router ASN exactly — get either wrong and the BGP session never
# establishes. advertised_route_priority is the MED value sent to the
# peer: LOWER numbers are preferred. Both tunnels here use 100, so
# traffic load-balances across them instead of favoring one path.
resource "google_compute_router_peer" "router1_peer1" {
  name                      = "router1-peer1"
  router                    = google_compute_router.router1.name
  region                    = "us-central1"
  peer_ip_address           = "169.254.0.2"
  peer_asn                  = 64515
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router1_interface1.name
}

# Same idea, but for tunnel2 (the second, redundant path). Note the
# different /30 — each tunnel needs its OWN unique link-local subnet for
# its BGP session; you can't reuse 169.254.0.0/30 twice.
resource "google_compute_router_interface" "router1_interface2" {
  name       = "router1-interface2"
  router     = google_compute_router.router1.name
  region     = "us-central1"
  ip_range   = "169.254.1.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel2.name
}

resource "google_compute_router_peer" "router1_peer2" {
  name                      = "router1-peer2"
  router                    = google_compute_router.router1.name
  region                    = "us-central1"
  peer_ip_address           = "169.254.1.1" # Site B's interface2 address
  peer_asn                  = 64515         # Site B's router ASN
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router1_interface2.name
}