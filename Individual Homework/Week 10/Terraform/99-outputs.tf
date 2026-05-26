output "vpc_name" {
  value = google_compute_network.week10.name
}

output "health_check_name" {
  value = google_compute_health_check.week10app.name
}
output "load_balancer_ip" {
  description = "Global static IP address of the HTTP load balancer."
  value       = google_compute_global_address.app.address
}
output "load_balancer_url" {
  description = "HTTP URL of the load balancer"
  value       = "http://${google_compute_global_address.app.address}"
}

output "backend_service_name" {
  description = "Name of the backend service resource."
  value       = google_compute_backend_service.week10app.name
}

output "url_map_name" {
  description = "Name of the URL map resource."
  value       = google_compute_url_map.app.name
}