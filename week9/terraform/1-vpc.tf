# Resource used to create this VPC👉 https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network

resource "google_compute_network" "week9hw-vpc" {
  project                 = "class75sier1"
  name                    = "week9hw-vpc"
  auto_create_subnetworks = true
}