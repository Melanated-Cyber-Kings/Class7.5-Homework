output "vm_external_ip" {
  description = "External IP address of the instance"
  value       = google_compute_instance.instance-20260514-202313.network_interface.0.access_config.0.nat_ip
}

output "vm_internal_ip" {
  description = "Internal IP address of the instance"
  value       = google_compute_instance.instance-20260514-202313.network_interface.0.network_ip
}

output "vm_name" {
  description = "Name of the instance"
  value       = google_compute_instance.instance-20260514-202313.name
}

output "vm_id" {
  description = "ID of the instance"
  value       = google_compute_instance.instance-20260514-202313.id
}

output "vm_self_link" {
  description = "Self Link of the instance"
  value       = google_compute_instance.instance-20260514-202313.self_link
}