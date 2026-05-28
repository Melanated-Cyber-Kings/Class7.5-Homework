terraform {
  required_version = ">= 1.10.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.32.0"
    }
  }
}

provider "google" {
  project = "class7-5-sovereignman"
  region  = "us-central1"
}