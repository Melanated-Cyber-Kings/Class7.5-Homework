terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.30.0"
    }
  }
}

provider "google" {
  project     = "class7-5-sovereignman"
  region      = "us-central1"
  zone        = "us-central1-c"
}