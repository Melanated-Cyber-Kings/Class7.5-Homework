variable "fleming-friday-floripa" {
  description = "GCP project ID where both networks are created"
  type        = string
}

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.31.0"
    }
  }
}

provider "google" {
  project = var.fleming-friday-floripa
  region  = "us-central1"
}