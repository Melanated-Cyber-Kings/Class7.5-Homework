variable "project_id" {
  description = "project ID"
  type        = string
  default     = "seir-netrunner"
}

variable "zone" {
  description = "MIG zone"
  type        = string
  default     = "us-central1-a"
}

variable "vpc_name" {
  description = "VPC"
  type        = string
  default     = "iowa-hq"
}

variable "subnet_name" {
  description = "subnet name"
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
