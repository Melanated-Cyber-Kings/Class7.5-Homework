
resource "google_compute_instance" "default" {
  name         = "cloud-workv2"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-stream-10"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }


  metadata_startup_script = file("${path.module}/startup-for-rhel.sh")


}