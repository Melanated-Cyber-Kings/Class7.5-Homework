resource "google_compute_instance_template" "week9_supera" {
  name        = "week9-supera"
  description = "week9-supera"

  machine_type = "e2-medium"
  tags         = ["http-server"]

  disk {
    source_image = "debian-cloud/debian-12"
    auto_delete  = true
    boot         = true
    disk_size_gb = 10
  }

  network_interface {
    network    = google_compute_network.week9.name
    subnetwork = google_compute_subnetwork.week9.name

    access_config {
      # This allows you to assign a public, external IP to a VM.
    }
  }

  metadata_startup_script = file("./supera.sh")

  lifecycle {
    create_before_destroy = true
  }
}
# Lifecycle is optional. It creates new resource before deleting the old one, avoiding downtime. Best practice for production.

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template#using-with-instance-group-manager