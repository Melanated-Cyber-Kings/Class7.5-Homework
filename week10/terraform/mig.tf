# Instance Template 
resource "google_compute_instance_template" "vm_template" {
  name         = "my-test-instance-template"
  machine_type = "n2-standard-2"
  region       = "us-east1"

  disk {
    source_image = "centos-cloud/centos-stream-10"
    disk_size_gb = 100
    boot         = true
    auto_delete  = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private.id
    access_config {}
  }

  tags = ["http-server", "ssh", "http"]

  # required for foo
  metadata_startup_script = file("${path.module}/../startup.sh")
}

# Autohealing Health Check
resource "google_compute_region_health_check" "autohealing" {
  name   = "my-health-check"
  region = "us-east1"

  # Turn Logs On
  log_config {
    enable = true
  }

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

# Instance Group 
resource "google_compute_region_instance_group_manager" "mig" {
  name               = "my-runbook-mig"
  region             = "us-east1" 
  base_instance_name = "app-node"
  
  target_size        = 4

  version {
    instance_template = google_compute_instance_template.vm_template.id
  }

  
  auto_healing_policies {
    health_check      = google_compute_region_health_check.autohealing.id
    initial_delay_sec = 300
  }

  named_port {
    name = "http"
    port = 80
  }
}