resource "google_compute_network" "iowa_hq" {
  name                    = "iowa-vpc"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "zerocore" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.iowa_hq.self_link
}

# Firewall HTTP
resource "google_compute_firewall" "allow_http" {
  name    = "${var.vpc_name}-allow-http"
  network = google_compute_network.iowa_hq.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http"]
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}
