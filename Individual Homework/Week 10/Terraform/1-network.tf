resource "google_compute_network" "week10" {
  name                    = "week10"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "week10" {
  name          = "week10"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.week10.id
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork