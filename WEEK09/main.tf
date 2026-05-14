# 
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.31.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "fleming-friday-floripa"
  region  = "us-central1"

}