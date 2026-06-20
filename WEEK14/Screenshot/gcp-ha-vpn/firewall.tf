# ---------------------------------------------------------------------------
# firewall.tf
# GCP VPCs deny all ingress by default. The VPN tunnel and BGP session
# will come up fine without these rules, but no actual traffic (pings,
# app traffic, etc.) is allowed to cross between the two networks until
# rules like these exist.

# Allow traffic INTO network1 (10.0.0.0/16) FROM network2 (192.168.0.0/16).
resource "google_compute_firewall" "allow_from_network2" {
  name    = "allow-ingress-from-network2"
  network = google_compute_network.network1.name # attach to network1

  allow {
    protocol = "tcp" # e.g. SSH, HTTP, app traffic
  }
  allow {
    protocol = "udp" # e.g. DNS, some app traffic
  }
  allow {
    protocol = "icmp" # so `ping` works for connectivity testing
  }

  # Only allow traffic that originates from network2's CIDR range.
  source_ranges = ["192.168.0.0/16"]
}

# Mirror rule: allow traffic INTO network2 FROM network1.
resource "google_compute_firewall" "allow_from_network1" {
  name    = "allow-ingress-from-network1"
  network = google_compute_network.network2.name # attach to network2

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/16"]
}

# NOTE (runbook): these rules are deliberately wide open (all TCP/UDP/ICMP)
# so you can confirm end-to-end connectivity first. Once a ping/curl test
# works across the tunnel, come back and narrow `allow` down to only the
# specific ports your applications actually need.(icmp)
