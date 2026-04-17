#The GCS backend bucket must be created first, 
#before terraform init, because Terraform cannot use a backend that does not already exist.

# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    # Change the bucket name to match the bucket you created 
    # in the prerequisites step.
    # bucket = "lizzoluvtf"
    # Change the bucket name to match the bucket you created
    # in the prerequisites step.
    bucket = "awesome-majestic-terraform-state"

    prefix = "terraform/state"
  }
}

