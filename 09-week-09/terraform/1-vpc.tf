resource "google_compute_network" "custom_vpc" {
  name                    = "custom-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom_subnet" {
  name          = "custom-subnet"
  ip_cidr_range = "10.0.255.0/24"
  network       = google_compute_network.custom_vpc.id
}

# Allow HTTP from anywhere
resource "google_compute_firewall" "allow_http" {
  name    = "fw-allow-http"
  network = google_compute_network.custom_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Allow from anywhere
  source_ranges = ["0.0.0.0/0"]

  # Apply to instances with the "web" tag
  target_tags = ["web"]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network.html
# https://oneuptime.com/blog/post/2026-02-17-how-to-use-terraform-to-create-a-vpc-with-private-google-access-and-cloud-nat-for-gke/view
# https://oneuptime.com/blog/post/2026-02-23-how-to-create-gcp-firewall-rules-with-terraform/view