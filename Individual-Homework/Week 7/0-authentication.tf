#This is the TERRAFORM PROVIDER CONFIG FILE from the Hashicorp site


terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.30.0"
    }
  }
}

provider "google" {
  project = "cloud2026-490221"
  region  = "us-central1" # Configuration options
}