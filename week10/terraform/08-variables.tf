variable "project-name" {
  type        = string
  description = "Running name for project sources"
}

variable "region" {
  type = string
}
variable "service_port" {
  type = number
}

variable "service_port_name" {
  type = string
}

variable "target_tags" {
  type = list(string)
}