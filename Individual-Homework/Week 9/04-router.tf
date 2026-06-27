# Reviewed Router info here https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router

resource "google_compute_router" "week9-router" {
  name    = "week9-router"
  network = google_compute_network.week9hw.id
  region  = "us-central1"
  bgp {
    asn               = 64514
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]

  }
}
