# Setup GCP VM instance in existing default VPC network and subnet.

# Set Data sources to get default VPC and subnet configuration.
data "google_compute_network" "default" {
  name = "default"
}

data "google_compute_subnetwork" "default" {
  name   = "default"
  region = var.region
}

# Pulls the bash script  and runs it on the VM startup.
locals {
  startup_script = file("${path.root}/../scripts/startup.sh")
}

# Virtual machine instance.
resource "google_compute_instance" "mephisto_vm" {
  name         = var.vm_name
  machine_type = "n2-standard-2"
  zone         = var.zone

  tags = ["http-server"] # Tag to apply the firewall rule

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-stream-10" # Uses latest CentOS 10 image.
      size  = 100                             # Size of the boot disk in GB.
    }
  }

  network_interface {
    network    = data.google_compute_network.default.self_link
    subnetwork = data.google_compute_subnetwork.default.self_link
    access_config {}
  }


  metadata = {
    student_name = var.student_name
  }

  metadata_startup_script = local.startup_script


}

