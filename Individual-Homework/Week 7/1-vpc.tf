resource "google_compute_network" "week7hw-food" {
  project                 = "cloud2026-490221"
  name                    = "week7hw-food"
  auto_create_subnetworks = true
  mtu                     = 1460
}

resource "local_file" "favorite_food" {
  content  = "Ice-Cream" # Replace with your favorite food
  filename = "${path.module}/food.txt"
}