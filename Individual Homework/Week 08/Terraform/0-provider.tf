terraform {
  required_version = ">= 1.10" # Minimum version required for the Google provider
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.31.0"
    }
  }
}

provider "google" {
  project = "class7-5-sovereignman"
  region  = "us-central1"
  zone    = "us-central-a"
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs