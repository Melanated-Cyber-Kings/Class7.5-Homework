terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.33.0"
    }
  }
}

provider "google" {
  project = "seir-netrunner"
  region  = "us-central1"
}
