terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.29.0"
    }
    
    local = {
      source  = "hashicorp/local"
      version = "2.8.0"
    }
  }
}

provider "google" {
   project     = "seir-project-490500"
  region      = "us-central1"
}