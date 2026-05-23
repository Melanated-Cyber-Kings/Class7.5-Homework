output "mig_name" {
  value = google_compute_instance_group_manager.mig.name
}

output "mig_size" {
  value = google_compute_instance_group_manager.mig.target_size
}

output "load_balancer_ip" {
  value = google_compute_global_address.lb_ip.address
}

output "health_check_status" {
  value = google_compute_health_check.http_health_check.name
}

output "load_balancer_forwarding_rule" {
  value = google_compute_global_forwarding_rule.http_forwarding_rule.name
}
