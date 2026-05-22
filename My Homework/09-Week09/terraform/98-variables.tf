variable "project_id" {
  description = "GCP project ID. Must be provided by the user."
  type        = string
}

variable "region" {
  description = "Region for resources."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone for the MIG."
  type        = string
  default     = "us-central1-a"
}

variable "student_name" {
  description = "Student name stored in VM metadata."
  type        = string
  default     = "Van"
}

variable "vpc_name" {
  description = "Custom VPC name."
  type        = string
  default     = "first"
}

variable "subnet_name" {
  description = "Custom subnet name."
  type        = string
  default     = "first-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet."
  type        = string
  default     = "10.10.0.0/24"
}

variable "machine_type" {
  description = "Machine type for MIG instances."
  type        = string
  default     = "n2-standard-2"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB."
  type        = number
  default     = 100
}

variable "mig_target_size" {
  description = "Number of instances in the MIG."
  type        = number
  default     = 3
}