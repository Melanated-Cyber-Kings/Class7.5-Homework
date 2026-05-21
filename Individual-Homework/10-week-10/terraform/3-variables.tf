variable "project_id" {
  description = "GCP project ID. Must be provided by the user."
  type        = string
}

variable "region" {
  description = "Region for resources."
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "Zones for the MIG."
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

variable "student_name" {
  description = "Student name stored in VM metadata."
  type        = string
  default     = "Mister Majestik"
}

variable "vpc_name" {
  description = "Custom VPC name."
  type        = string
  default     = "mephisto"
}

variable "subnet_name" {
  description = "Custom subnet name."
  type        = string
  default     = "mephisto-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet."
  type        = string
  default     = "10.100.1.0/24"
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

variable "lb_name" {
  description = "Name of the external HTTP load balancer."
  type        = string
  default     = "mephisto-lb"
}

variable "backend_timeout_sec" {
  description = "Timeout for backend service."
  type        = number
  default     = 30
}