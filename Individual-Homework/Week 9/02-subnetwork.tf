# Gained info from Udemy https://www.udemy.com/course/terraform-for-beginners-using-google-cloud/learn/lecture/28659708#overview
# Also referenced  https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network

resource "google_compute_subnetwork" "szero_week9" {
  name          = "szero-week9"
  network       = google_compute_network.week9hw.id
  ip_cidr_range = "10.1.0.0/24"
  region        = "us-central1"
}