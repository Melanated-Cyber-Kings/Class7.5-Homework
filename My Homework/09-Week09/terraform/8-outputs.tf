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

output "mig_name" {
  description = "Name of the Managed Instance Group."
  value       = google_compute_instance_group_manager.first_mig.name
}

output "mig_size" {
  description = "Number of instances in the MIG."
  value       = google_compute_instance_group_manager.first_mig.target_size
}