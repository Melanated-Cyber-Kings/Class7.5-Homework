terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project     = "fleming-friday-floripa"
  region      = "us-central1"
}

module "vpc" {
    source  = "terraform-google-modules/network/google//modules/vpc"
    version = "~> 9.3"

    project_id   = "fleming-friday-floripa"
    network_name = "network1-vpc"
    routing_mode = "GLOBAL"

    shared_vpc_host = false
}