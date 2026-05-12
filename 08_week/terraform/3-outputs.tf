# Output internal and external IP addresses of the VM
output "internal_ip" {
  value = google_compute_instance.seir-vm.network_interface[0].network_ip
}

output "external_ip" {
  value = google_compute_instance.seir-vm.network_interface[0].access_config[0].nat_ip
}

# Output the name, id and self_link attributes
output "vm_name" {
  value = google_compute_instance.seir-vm.name
}

output "vm_id" {
  value = google_compute_instance.seir-vm.id
}

output "vm_self_link" {
  value = google_compute_instance.seir-vm.self_link
}
