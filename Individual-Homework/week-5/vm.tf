resource "google_compute_instance" "vm_instance" {
  name         = "week-5-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {} # Assigns an ephemeral public IP
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  tags = ["http-server"]

}