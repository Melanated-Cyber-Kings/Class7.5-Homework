output "mig_name" {
  description = "Name of the Managed Instance Group."
  value       = google_compute_instance_group_manager.mephisto_mig.name
}

output "mig_size" {
  description = "Number of instances in the MIG."
  value       = google_compute_instance_group_manager.mephisto_mig.target_size
}