output "vpc_name" {
  value = google_compute_network.week10.name
}

output "health_check_name" {
  value = google_compute_health_check.week10app.name
}

output "load_balancer_ip" {
  value = "http://${google_compute_global_address.app.address}"
}