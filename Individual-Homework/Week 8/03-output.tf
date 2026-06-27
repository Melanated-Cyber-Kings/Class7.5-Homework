# https://developer.hashicorp.com/terraform/language/values/outputs

# output "instance_external_ip" {
#   value       = "http://${google_compute_instance.sample-vm.network_interface[0].access_config[0].nat_ip}"
#   description = "The external IP address of the GCE instance."
# }

# output "instance_external_ips" {
#   value = {
#     vm1 = "http://${google_compute_instance.sample-vm.network_interface[0].access_config[0].nat_ip}"
#     vm2 = "http://${google_compute_instance.sample-vm.network_interface[0].access_config[0].nat_ip}"
#   }
#   description = "External IPs of both VMs"
# }




#Internal IP
# Replace "google_compute_instance.vm_instance" with your actual resource name
output "vm_internal_ip" {
  description = "The internal IP address of the VM"
  value       = google_compute_instance.default.network_interface[0].network_ip
}


#External IP Output
output "vm_external_ip" {
  description = "The external IP address of the VM"
  value       = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}