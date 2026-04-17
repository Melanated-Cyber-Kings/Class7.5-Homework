# Here we declare the variables that we will use in our Terraform configuration files. This allows us to easily manage and reuse values across our configuration without hardcoding them directly into the files.
# In this example, we are declaring variables for the GCP project and region, which we will use in our provider configuration and other resources.

variable "project" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "The GCP region where we want resources to be deployed."
  type        = string
}