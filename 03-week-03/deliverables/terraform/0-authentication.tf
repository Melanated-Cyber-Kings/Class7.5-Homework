# Authenticate to GCP

# Ensure Google Cloud CLI is set in the terminal via gcloud init

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "class75-michaelanunda"
  region  = "us-central1"
}