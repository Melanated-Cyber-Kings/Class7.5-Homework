# Creating a VPC
# https://www.geeksforgeeks.org/devops/how-to-create-vpc-in-gcp-using-terraform/

resource "google_compute_network" "my-network-vpc" {
  project                 = "fleming-friday-floripa"
  name                    = "my-network-vpc"
  auto_create_subnetworks = true
}