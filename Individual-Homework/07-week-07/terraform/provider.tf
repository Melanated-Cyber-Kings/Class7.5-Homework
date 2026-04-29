# Set terraform software version and providers for google cloud and local files.

# Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs
# Reference: https://registry.terraform.io/providers/hashicorp/local/latest/docs

terraform {
  required_version = ">=1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.30.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.8.0"
    }
  }
}

# Google provider configuration
# Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference

provider "google" {
  project = var.project_id
  region  = var.region

}