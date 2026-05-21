# Set provider configuration for GCP.
provider "google" {
  project = var.project_id
  region  = var.region

}

    