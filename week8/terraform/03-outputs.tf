output "internal_ip" {
  description = "displays the internal IP of the VM"
  value       = google_compute_instance.week8.network_interface.0.network_ip
}

output "external_ip" {
  description = "displays the external IP of the VM"
  value       = google_compute_instance.week8.network_interface.0.access_config.0.nat_ip
}

output "vm-name" {
  description = "displays the name of the VM"
  value       = google_compute_instance.week8.name
}
output "self-link" {
  description = "displays the URI of the VM"
  value       = google_compute_instance.week8.self_link
}

output "instance-id" {
  description = "displays the instance ID of the VM"
  value       = google_compute_instance.week8.instance_id
}
