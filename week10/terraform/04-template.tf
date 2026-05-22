resource "google_compute_instance_template" "class_template" {
  name         = "class-instance-template"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-12"
    disk_type    = "pd-balanced"
    disk_size_gb = 10
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnetworks.id
    access_config {}
  }

  tags = ["lews-tag"]

  metadata = {
    startup-script = file("${path.module}/startup.sh")
  }
}
