output "vpc" {
  description = "Name of VPC in GCP"
  value       = google_compute_network.vpc_network.name
}