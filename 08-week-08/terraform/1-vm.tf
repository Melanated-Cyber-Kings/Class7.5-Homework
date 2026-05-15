resource "google_compute_instance" "instance-20260514-202313" {
  boot_disk {

    initialize_params {
      image = "projects/centos-cloud/global/images/centos-stream-10-v20260513"
      size  = 100
    }

  }

  machine_type = "n2-standard-2"

  metadata = {
    startup-script = "#!/bin/bash\n\n# this just is to keep those next two commands readable. $META and $HEADER get replaced with these lines\nMETA=\"http://metadata.google.internal/computeMetadata/v1/instance\"\nHEADER=\"Metadata-Flavor: Google\"\n\n# makes variables $NAME and $IP. Their values are from the curl command that hits the metadata service for VMs \nNAME=$(curl -H \"$HEADER\" \"$META/name\")\nIP=$(curl -H \"$HEADER\" \"$META/network-interfaces/0/ip\")\n\n# have the package manager grab the apache2 webserver \ndnf install -y httpd\n\n# write our html file to the default location apache2 looks for\ncat > /var/www/html/index.html << EOF\n<!DOCTYPE html>\n<html>\n<body>\n  <h1>VM Metadata</h1>\n  <h2>Instance Name: $NAME</h2>\n  <h2>Internal IP: $IP</h2>\n  <h2>Colombian prize included for free!</h2>\n  <figure>\n    <img src=\"https://test-1256099743.s3.us-east-2.amazonaws.com/Colombian/imgi_22_551283556_24677511425231259_7293143846320648055_n.jpg\" alt=\"Colombian prize!\" style=\"max-width:600px; width:100%; display:block; margin:1rem 0;\">\n    <figcaption>Colombian prize!</figcaption>\n  </figure>\n</body>\n</html>\nEOF\n\n# turn on apache2 service and make it turn on after the VM reboots too\nsystemctl enable --now httpd"
  }

  name = "instance-20260514-202313"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    subnetwork = "projects/class75-michaelanunda/regions/us-central1/subnetworks/default"
  }

  tags = ["http-server"]
  zone = "us-central1-a"
}