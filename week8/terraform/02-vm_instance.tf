resource "google_compute_instance" "week8" {
  name         = "week8-homework"
  machine_type = "n2-standard-2" # per instructions
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-stream-10" # use gcloud compute images list --filter 'family ~ centos' command to find image project and family
      size  = "100"                           # per instructions
    }
  }
  network_interface {
    network = "default"
    access_config {} #Left blank so that GCP assigns an ephemeral IP to the instance
  }
  metadata_startup_script = file("${path.module}/startup.sh") # pulls the startup script from our folder
  tags                    = ["http-server"]
}
