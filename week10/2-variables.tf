variable "project_id" {
  description = "GCP project ID. Must be provided by the user."
  type        = string
  default     = "class75-sier1"
}

variable "region" {
  description = "GCP region. Must be provided by the user."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone. Must be provided by the user."
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]  
}

variable "vpc_name" {
  description = "Name of the VPC network to be created."
  type        = string
  default     = "week10hw-vpc"
}

variable "subnet_name" {
  description = "Name of the subnet to be created."
  type        = string
  default     = "week10hw-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet."
  type        = string
  default     = "10.0.30.0/24"
}

variable "machine_type" {
  description = "Machine type for the Compute Engine instance."
  type        = string
  default     = "centos-100-v20240926"
}

variable "boot_disk_size_gb" {
  description = "Size of the boot disk in GB."
  type        = number
  default     = 100
}

variable "source_image" {
  description = "Source image for the Compute Engine instance."
  type        = string
  default     = "projects/centos-cloud/global/images/centos-100-v20240926"
}

variable "mig_name" {
  description = "Name of the Managed Instance Group."
  type        = string
  default     = "week10hw-mig"
}

variable "mig_instance_count" {
  description = "Number of instances in the Managed Instance Group."
  type        = number
  default     = 3
}

variable "instance_template_name" {
  description = "Name of the instance template."
  type        = string
  default     = "week10hw-instance-template"
}

variable "lb_name" {
  description = "Name of the load balancer."
  type        = string
  default     = "week10hw-lb"
}

variable "lb_backend_service_name" {
  description = "Name of the backend service for the load balancer."
  type        = string
  default     = "week10hw-backend-service"
}

variable "backend_port" {
  description = "Port number for the backend service."
  type        = number
  default     = 80
}

variable "ssh_source_ranges" {
  description = "Source ranges for the SSH firewall rule."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "health_check_name" {
  description = "Name of the health check for the load balancer."
  type        = string
  default     = "week10hw-health-check"
}

variable "health_check_port" {
  description = "Port number for the health check."
  type        = number
  default     = 80
}

variable "health_check_interval_sec" {
  description = "Interval in seconds between health checks."
  type        = number
  default     = 30
}

variable "health_check_timeout_sec" {
  description = "Timeout in seconds for health checks."
  type        = number
  default     = 10
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks before an instance is marked unhealthy."
  type        = number
  default     = 3
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks before an instance is marked healthy."
  type        = number
  default     = 3
}

variable "health_check_source_ranges" {
  description = "Source ranges for the health check firewall rule."
  type        = list(string)
  default     = ["35.191.0.0/16", "130.211.0.0/22"]
}