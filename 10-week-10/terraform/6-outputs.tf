output "vpc_id" {
  description = "id of the custom vpc"
  value       = google_compute_network.custom_vpc.id
}

output "mig_id" {
  description = "id of the regional mig"
  value       = google_compute_region_instance_group_manager.web_regional_mig.id
}

output "lb_ip" {
  description = "ipv4 of the load balancer"
  value       = "http://${google_compute_global_address.web.address}"
}

# https://developer.hashicorp.com/terraform/language/block/output