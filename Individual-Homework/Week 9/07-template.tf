# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_template

resource "google_compute_region_instance_template" "beef" {
  name_prefix  = "beef"
  machine_type = "e2-medium"
  tags         = ["foo", "bar", "http-server"]
  region       = "us-central1"

  // boot disk
  disk {
    source_image = "debian-cloud/debian-12"
    auto_delete  = true
    boot         = true
  }


  network_interface {
    subnetwork = google_compute_subnetwork.szero_week9.id

    access_config {
      // Ephemeral public IP

    }


  }

  metadata_startup_script = file("./startup.sh")

}