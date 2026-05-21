variable "service_port" {
  type        = number
  default     = 80
}

variable "service_port_name" {
  type        = string
  default     = "http"
}

variable "target_tags" {
  type        = list(string)
  default     = ["http-server"]

}

 variable "mig1" {
  type        = any
  default     = {
    instance_group = "https://www.googleapis.com/compute/v1/projects/class75-491118/zones/us-east1-b/instanceGroups/mig1-group"
    target_tags    = ["http-server"]
  }
 }

  variable "mig2" {
  type        = any
  default     = {
    instance_group = "https://www.googleapis.com/compute/v1/projects/class75-491118/zones/us-east1-b/instanceGroups/mig2-group"
    target_tags    = ["http-server"]
   }
  }