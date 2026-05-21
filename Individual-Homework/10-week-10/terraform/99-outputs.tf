output "mig_name" {
  description = "Name of the Managed Instance Group."
  value       = google_compute_instance_group_manager.mephisto_mig.name
}

output "mig_size" {
  description = "Number of instances in the MIG."
  value       = google_compute_instance_group_manager.mephisto_mig.target_size
}

output "load_balancer_ip" {
  description = "Global IP address of the load balancer."
  value       = google_compute_global_forwarding_rule.mephisto_forwarding_rule.ip_address
}

output "load_balancer_forwarding_rule" {
  description = "Name of the global forwarding rule for the load balancer."
  value       = google_compute_global_forwarding_rule.mephisto_forwarding_rule.name
}
