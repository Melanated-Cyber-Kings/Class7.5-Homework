output "vm_name" {
  description = "Name of the VM"
  value       = google_compute_instance.vm.name
}

output "vm_external_ip" {
  description = "External IP address of the VM"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "gcloud compute ssh ${google_compute_instance.vm.name} --zone us-central1-a"
}

output "vm_internal_ip" {
  description = "Internal IP address of the VM"
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

output "favorite_food" {
  description = "Output showing my favorite food"
  # Used trimspace to remove any leading or trailing whitespace from the content of the file.
  # Otherwise the output end up looking like with extra spaces and EOT fields.
  value = "My favorite food is ${trimspace(local_file.favorite_food.content)}"
}