resource "google_compute_network" "week9" {
  name                    = "week9"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "week9" {
  name          = "week9"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.week9.id
}


#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork