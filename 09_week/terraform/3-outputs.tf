output "vpc_name" {
  value = google_compute_network.top-network.name
}

output "mig_name" {
  description = "MIG name"
  value       = google_compute_instance_group_manager.mig.name
}

output "mig_size" {
  description = "Number of instances"
  value       = google_compute_instance_group_manager.mig.target_size
}