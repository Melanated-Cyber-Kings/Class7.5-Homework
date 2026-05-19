resource "google_compute_network" "week9_vpc" {
  name                    = "week9-vpc"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "week9_subnet" {
  name          = "week9-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.week9_vpc.id
}


#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork