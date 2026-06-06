resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
  auto_create_subnetworks = true
  description = "Just a standard VPC network for our Terraform project"
}
