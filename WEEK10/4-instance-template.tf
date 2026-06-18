# lsCOLOMBIA
resource "google_compute_region_instance_template" "colombia" {
  name         = "colombia-template"
  description  = "Instance template for colombia backend"
  machine_type = "e2-medium"

  tags = ["lb-instance"]

  disk {
    source_image = "debian-cloud/debian-11"
    disk_size_gb = 10
    disk_type    = "pd-balanced"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {} # Assigns an ephemeral external IP to the vm instance for external access and health checks
    # Assigns a static external IP to each VM
  }#Access tire the quality of network that the internet allows

  metadata = {
    startup-script  = file("${path.module}/startup.sh")
    backend-name    = "colombia"          
  }

  lifecycle {
    create_before_destroy = true
  }
}

#THAILAND
resource "google_compute_region_instance_template" "thailand" {
  name         = "thailand-template"
  description  = "Instance template for thailand backend"
  machine_type = "e2-medium"

  tags = ["lb-instance"]

  disk {
    source_image = "debian-cloud/debian-11"
    disk_size_gb = 10
    disk_type    = "pd-balanced"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    startup-script  = file("${path.module}/startup.sh")
    backend-name    = "thailand" 
  }

  lifecycle {
    create_before_destroy = true
  }
}