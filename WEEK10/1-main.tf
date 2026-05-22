# provider version
terraform {
  required_version = ">= 1.10.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.3.10"
    }
  }
}

provider "google" {
  project = "fleming-friday-floripa"
  region  = "us-central1"
}