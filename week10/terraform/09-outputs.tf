output "network_name" {
  value       = google_compute_network.vpc_network.name
  description = "The name of the VPC being created"
}

output "load_balancer_public_ip" {
  description = "The external IPv4 assigned to the global forwarding rule."
  value       = module.gce-lb-http.external_ip
}

output "load_balancer_backend_services" {
  description = "The backend service resources map."
  value       = module.gce-lb-http.backend_services
  sensitive   = true
}

output "load_balancer_url_map" {
  description = "The default URL map used by the load balancer."
  value       = module.gce-lb-http.url_map
}

output "mig_instance_group" {
  description = "Link to the instance_group property of your regional instance group manager."
  value       = google_compute_region_instance_group_manager.mig.instance_group
}

output "mig_manager_id" {
  description = "The fully qualified resource ID of the regional instance group manager."
  value       = google_compute_region_instance_group_manager.mig.id
}