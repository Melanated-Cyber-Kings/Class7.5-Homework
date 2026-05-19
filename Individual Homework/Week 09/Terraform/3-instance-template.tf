resource "google_compute_instance_template" "week9_supera_template" {
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
    network    = google_compute_network.week9_vpc.name
    subnetwork = google_compute_subnetwork.week9_subnet.name

    access_config {

    }
  }

  metadata_startup_script = file("${path.module}/supera.sh")

  lifecycle {
    create_before_destroy = true
  }
}
# Lifecycle is optional. It creates new resource before deleting the old one, avoiding downtime. Best practice for production.

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template#using-with-instance-group-manager