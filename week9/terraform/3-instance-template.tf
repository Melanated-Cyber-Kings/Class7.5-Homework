# Resource used to create this instance template 👉 https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template

resource "google_compute_instance_template" "default" {
  name        = "appserver-template"
  description = "This template is used to create app server instances."

  tags = ["foo", "bar"]

  labels = {
    environment = "dev"
  }
# Scripts defined here run on every boot
  metadata_startup_script = <<-EOT
    #!/bin/bash
    # this just is to keep those next two commands readable. $META and $HEADER get replaced with these lines
META="http://metadata.google.internal/computeMetadata/v1/instance"
HEADER="Metadata-Flavor: Google"

# makes variables $NAME and $IP. Their values are from the curl command that hits the metadata service for VMs 
NAME=$(curl -H "$HEADER" "$META/name")
IP=$(curl -H "$HEADER" "$META/network-interfaces/0/ip")

# have the package manager grab the apache2 webserver 
dnf install -y httpd

# write our html file to the default location apache2 looks for
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<body>
  <h1>VM Metadata</h1>
  <h2>Instance Name: $NAME</h2>
  <h2>Internal IP: $IP</h2>
  <h2>Colombian prize included for free!</h2>
  <figure>
    <img src="https://test-1256099743.s3.us-east-2.amazonaws.com/Colombian/imgi_22_551283556_24677511425231259_7293143846320648055_n.jpg" alt="Colombian prize!" style="max-width:600px; width:100%; display:block; margin:1rem 0;">
    <figcaption>Colombian prize!</figcaption>
  </figure>
</body>
</html>
EOF

# turn on apache2 service and make it turn on after the VM reboots too
systemctl enable --now httpd

  EOT

  instance_description = "description assigned to instances"
  machine_type         = "n1-standard-1"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "centos-10-v20240624"
    auto_delete  = true
    boot         = true
  }

  // Use an existing disk resource
  disk {
    // Instance Templates reference disks by name, not self link
    source      = google_compute_disk.foobar.name
    auto_delete = false
    boot        = false
  }

  network_interface {
    network = "week9hw-vpc"
  }

  metadata = {
    foo = "bar"
  }
}

data "google_compute_image" "my_image" {
  family  = "centos-stream-10"
  project = "centos-cloud"
}

resource "google_compute_disk" "foobar" {
  name  = "existing-disk"
  image = data.google_compute_image.my_image.self_link
  size  = 100
  type  = "pd-ssd"
  zone  = "us-central1-a"
}
