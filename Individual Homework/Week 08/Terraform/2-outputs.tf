output "vm_name" {
  value = google_compute_instance.week8_hw_vm.name
}

output "vm_id" {
  value = google_compute_instance.week8_hw_vm.id
}

output "vm_self_link" {
  value = google_compute_instance.week8_hw_vm.self_link
}

output "internal_ip" {
  value = google_compute_instance.week8_hw_vm.network_interface[0].network_ip
}

output "external_ip" {
  value = google_compute_instance.week8_hw_vm.network_interface[0].access_config[0].nat_ip
}

# https://docs.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-outputs