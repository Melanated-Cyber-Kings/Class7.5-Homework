#COLOMBIA 
resource "google_compute_instance_group_manager" "colombia" {
  name               = "colombia-instance-group"
  base_instance_name = "colombia-instance"
  zone               = "us-central1-a"
  description        = "Instance group for colombia backend"

  version {
    instance_template = google_compute_instance_template.colombia.id
  }

  target_size = 2

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.colombia_health_check.id
    initial_delay_sec = 30
  }
}

#THAILAND 
resource "google_compute_instance_group_manager" "thailand" {
  name               = "thailand-instance-group"
  base_instance_name = "thailand-instance"
  zone               = "us-central1-b"
  description        = "Instance group for thailand backend"

  version {
    instance_template = google_compute_instance_template.thailand.id
  }

  target_size = 2

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.thailand_health_check.id
    initial_delay_sec = 30
  }
}

  