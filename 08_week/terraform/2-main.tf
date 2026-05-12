# Default Network
data "google_compute_network" "default" {
  name = "default"
}

# Default Subnetwork
data "google_compute_subnetwork" "default" {
  name   = "default"
  region = "us-central1"
}

# VM startup script
locals {
  startup_script = file("${path.module}/startup.sh")
}

# VM instance.
resource "google_compute_instance" "seir-vm" {
  name         = "seir-vm"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  tags = ["http-server"] # firewall rule

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-stream-10" # CentOS 10 image.
      size  = 100                             # Size of boot disk.
    }
  }

  network_interface {
    network    = data.google_compute_network.default.self_link
    subnetwork = data.google_compute_subnetwork.default.self_link
    access_config {}
  }


  metadata = {
    student_name = "thomas bell"
  }

  metadata_startup_script = local.startup_script


}
