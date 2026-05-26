variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "class7-5-sovereignman"
}

variable "app_name" {
  description = "Homework week"
  type        = string
  default     = "weekx"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone"
  type        = string
  default     = "us-central1-a"
}

variable "vpc_name" {
  description = "VPC"
  type        = string
  default     = "vpc"
}

variable "subnet_name" {
  description = "subnet name"
  type        = string
  default     = "subnet"
}

variable "subnet_cidr" {
  description = "CIDR range"
  type        = string
  default     = "10.10.0.0/24"
}