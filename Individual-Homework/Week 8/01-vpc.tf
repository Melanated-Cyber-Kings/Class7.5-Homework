resource "google_compute_network" "week8hwv2" {
  project                 = "cloud2026-490221"
  name                    = "week8hwv2"
  auto_create_subnetworks = true
  mtu                     = 1460
}
