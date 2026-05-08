# Provide outputs to console after terraform successfully applies the configuration

# Output internal and external IP addresses of the VM
output "vm_internal_ip" {
  value = google_compute_instance.mephisto_vm.network_interface[0].network_ip
}

output "vm_external_ip" {
  value = google_compute_instance.mephisto_vm.network_interface[0].access_config[0].nat_ip
}

# Output the name, id and self_link attributes
output "vm_name" {
  value = google_compute_instance.mephisto_vm.name
}

output "vm_id" {
  value = google_compute_instance.mephisto_vm.id
}

output "vm_self_link" {
  value = google_compute_instance.mephisto_vm.self_link
}

