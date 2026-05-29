output "mig_name" {
  description = "Name of the Managed Instance Group."
  value       = google_compute_region_instance_group_manager.mephisto_mig.name
}

# This only provided what was set in configuration not actual
# number of instances running in the MIG.
# output "mig_size" {
#   description = "Number of instances in the MIG."
#   value       = google_compute_region_instance_group_manager.mephisto_mig.target_size
# }

# Retrieve actual MIG instance size after deployment for verification.

data "google_compute_region_instance_group_manager" "mephisto_mig" {
  name       = google_compute_region_instance_group_manager.mephisto_mig.name
  region     = var.region
  depends_on = [google_compute_region_instance_group_manager.mephisto_mig]
}
output "actual_mig_size" {
  description = "Actual number of instances in the MIG after deployment."
  value       = data.google_compute_region_instance_group_manager.mephisto_mig.target_size
}

output "load_balancer_ip" {
  description = "Global IP address of the load balancer."
  value       = google_compute_global_address.mephisto_lb_ip.address
}

output "load_balancer_forwarding_rule" {
  description = "Name of the global HTTPS forwarding rule for the load balancer."
  value       = google_compute_global_forwarding_rule.mephisto_forwarding_rule_https.name
}

# Provide DNS name for load balancer as well.
output "load_balancer_dns_name" {
  description = "DNS name for the load balancer."
  value       = google_dns_record_set.mephisto_dns_record.name
}

# For troubleshooting, output client IP address.
# Uncomment this block if you have the SSH firewall rule active
# and want to see what IP address will be used for access.

# output "client_ip" {
#   description = "Client IP address for troubleshooting."
#   value       = data.http.client_workstation_ip.response_body
# }

