output "vpc_name" {
  value = google_compute_network.iowa_hq.name
}

output "mig_name" {
  description = "MIG name"
  value       = google_compute_region_instance_group_manager.webserver.name
}

output "load_balancer_ip" {
  value = "http://${google_compute_global_address.web_lb_ip.address}"
}