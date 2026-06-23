resource "google_compute_instance_template" "supera" {
  name_prefix  = "template-supera"
  machine_type = "e2-medium"
  tags         = ["web"]

  disk {
    source_image = "projects/debian-cloud/global/images/debian-12-bookworm-v20260513"
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
  }

  network_interface {
    network    = google_compute_network.custom_vpc.id
    subnetwork = google_compute_subnetwork.custom_subnet.id

    access_config {} # this block allows you to assign a public external IP to a virtual machine
  }

  metadata_startup_script = file("${path.module}/supera.sh")
}







# https://oneuptime.com/blog/post/2026-02-23-how-to-create-gcp-managed-instance-groups-with-terraform/view
# https://developer.hashicorp.com/terraform/language/functions/file