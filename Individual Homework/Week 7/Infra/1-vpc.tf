resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}


output "vpc_name" {
  value       = google_compute_network.vpc_network.name
}
