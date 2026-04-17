

#Chewbacca: The Force needs coordinates.
#You need this first in order to see if you can authenticate to GCP

#You need to change Project, Region, and Creds

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  # Set the project value to your GCP project ID. 
  # You can find this in the Google Cloud Console under "IAM & Admin" > "Settings",
  # in the project dashboard or via the command line using `gcloud config get-value project`.


  # project = "thailand-433607"
  # region  = "us-central1"

  # In my example I am using a variable for the project and 
  # region, which I will set in the terraform.tfvars file.

  project = var.project
  region  = var.region
}