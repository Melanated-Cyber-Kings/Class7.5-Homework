output "vpc_name" {
  value = google_compute_network.top.name
}

output "mig_name" {
  description = "MIG name"
  value       = google_compute_region_instance_group_manager.webserver.name
}
