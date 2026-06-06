terraform {
  required_version = ">= 1.5.0"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.30.0" #This is here to make sure that I have a base version and allows the system to pick any compatible version in this range
    }
  }
}