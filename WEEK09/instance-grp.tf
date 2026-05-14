resource "google_compute_instance_group_manager" "instance_group" {
  name               = "lb-instance-group"
  base_instance_name = "lb-instance"
  zone               = "us-central1-a"
  description        = "Instance group for my load balancing"

  version {
    instance_template = google_compute_instance_template.lb_instance_template.id
  }

  target_size = 2

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.lb_health_check.id
    initial_delay_sec = 30
  }

  wait_for_instances = true

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}