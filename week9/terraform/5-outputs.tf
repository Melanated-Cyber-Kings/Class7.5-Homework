output "vm_internal_ip" {
  description = "Internal IP address of the VM"
  value       = google_compute_instance_template.default.name
}

output "vm_external_ip" {
  description = "External IP address of the VM"
  value       = google_compute_instance_template.default.name
}