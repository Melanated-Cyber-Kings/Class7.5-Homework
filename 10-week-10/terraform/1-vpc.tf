locals {
  allow_all_source_range = "0.0.0.0/0"
  target_tag_name        = "web"
}

resource "google_compute_network" "custom_vpc" {
  name                    = var.network_resource_name.vpc
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom_subnet" {
  name          = var.network_resource_name.subnet
  ip_cidr_range = "10.0.255.0/24"
  network       = google_compute_network.custom_vpc.id
}

# Allow HTTP from anywhere
resource "google_compute_firewall" "allow_http" {
  name    = var.network_resource_name.http-firewall
  network = google_compute_network.custom_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Allow from anywhere
  source_ranges = [local.allow_all_source_range]

  # Apply to instances with the "web" tag
  target_tags = [local.target_tag_name]
}

# Allow SSH from anywhere
resource "google_compute_firewall" "allow_ssh" {
  name    = var.network_resource_name.ssh-firewall
  network = google_compute_network.custom_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Allow from anywhere
  source_ranges = [local.allow_all_source_range]

  # Apply to instances with the "web" tag
  target_tags = [local.target_tag_name]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network.html
# https://oneuptime.com/blog/post/2026-02-17-how-to-use-terraform-to-create-a-vpc-with-private-google-access-and-cloud-nat-for-gke/view
# https://oneuptime.com/blog/post/2026-02-23-how-to-create-gcp-firewall-rules-with-terraform/view