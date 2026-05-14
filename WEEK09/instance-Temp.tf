resource "google_compute_instance_template" "lb_instance_template" {
  name         = "lb-instance-template"
  description  = "Instance template for load balancer instances"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
    disk_size_gb = 10
    disk_type    = "pd-balanced"
    auto_delete  = true  #Delete disk when VM is deleted, avoids orphaned disks
    boot         = true  # marks this as the boot disk
  }

  network_interface {
    network = "default"
    access_config {}   
  }

  metadata = {
    startup-script = file("${path.module}/startup.sh")
  }

  lifecycle {
    create_before_destroy = true  # Creates new template before deleting old one during updates
  }
}