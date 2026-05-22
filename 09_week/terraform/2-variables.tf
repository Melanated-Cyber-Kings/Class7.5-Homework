variable "project_id" {
  description = "project ID"
  type        = string
  default = "seir-netrunner"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "MIG zone"
  type        = string
  default     = "us-central1-a"
}

variable "student_name" {
  description = "my name"
  type        = string
  default     = "Thomas Bell"
}

variable "vpc_name" {
  description = "VPC"
  type        = string
  default     = "top-network"
}

variable "subnet_name" {
  description = "subnet name."
  type        = string
  default     = "subnet"
}

variable "subnet_cidr" {
  description = "CIDR range"
  type        = string
  default     = "10.0.255.0/24"
}

variable "machine_type" {
  description = "Machine type"
  type        = string
  default     = "n2-standard-2"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size"
  type        = number
  default     = 100
}

variable "mig_target_size" {
  description = "Number of instances"
  type        = number
  default     = 3
}