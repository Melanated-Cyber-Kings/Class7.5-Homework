terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.31.0"
    }
  }
}

provider "google" {
  project = local.project
  region  = local.region
}

locals {
  project = "seir-project-490500"
  region  = "us-central1"
}