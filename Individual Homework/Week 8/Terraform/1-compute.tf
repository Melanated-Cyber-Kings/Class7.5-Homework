resource "google_compute_instance" "week8_hw_vm" {
  # Required arguments
  name         = "week8-hw-vm"   # (Required) Unique resource name as discussed in README
  machine_type = "n2-standard-2" # (Required) N-series machine family as instructed
  zone         = "us-central1-a" # (Optional) But best practice to include

  boot_disk { # (Required) Boot disk structure
    initialize_params {
      image = "centos-cloud/centos-stream-10" # CentOS Stream 10 image
      size  = 100                             # Disk size, 100GB as instructed
    }
  }

  network_interface {   
    network = "default" # Use the default VPC

    access_config {

    }
  }

  tags = ["http-server"]
  # Firewall tag to open port 80

  metadata_startup_script = file("${path.module}/startup.sh")
  # Startup script from startup.sh file
}

#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance