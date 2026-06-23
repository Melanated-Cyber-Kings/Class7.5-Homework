# terraform block for the latest version of the GCP provider

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.32.0"
    }
  }
}

# provider block for the project and region where infrastructure will be provisioned in GCP

provider "google" {
  project = "class75-mikeanunda"
  region  = "us-central1"
}