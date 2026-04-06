provider "google" {
  #Chewbacca: The Force needs coordinates.
  credentials = file("credentials.json")
  project = var.project_id
  region  = var.region
  zone    = var.zone
}