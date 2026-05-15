output "vpc_name" {
  value = google_compute_network.week9_vpc.name
}

output "mig_name" {
  value = google_compute_region_instance_group_manager.week9_mig.name
}

output "health_check_name" {
  value = google_compute_health_check.week9_hc.name
}

output "instance_template_name" {
  value = google_compute_instance_template.week9_supera_template.name
}