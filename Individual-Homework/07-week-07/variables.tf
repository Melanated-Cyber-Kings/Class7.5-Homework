# Setup variables to make changes easier to make in terraform code.

# Reference: https://developer.hashicorp.com/terraform/language/values/variables

variable "project_id" {
  description = "GCP project identification"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}


variable "favorite_food" {
  description = "My favorite food"
  type        = string
  default     = "Philly Cheese Steak"
}
