output "vpc_id" {
  description = "id of the custom vpc"
  value       = google_compute_network.custom_vpc.id
}

output "subnet_id" {
  description = "id of the custom subnet"
  value       = google_compute_subnetwork.custom_subnet.id
}

output "firewall_id" {
  description = "id of the firewall rule for the custom vpc"
  value       = google_compute_firewall.allow_http.id
}

output "mig_id" {
  description = "id of the regional mig"
  value       = google_compute_region_instance_group_manager.web_regional_mig.id
}