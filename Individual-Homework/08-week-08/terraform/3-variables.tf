# Setup variables for GCP.

variable "project_id" {
  description = "The GCP project ID, use the project ID from the GCP console."
  type        = string

}

variable "region" {
  description = "The GCP region where you want your resources to be deployed."
  type        = string
  default     = "us-central1"
}

variable "vm_name" {
  description = "The name of the virtual machine instance."
  type        = string
  default     = "mephisto-vm"
}

variable "zone" {
  description = "The GCP zone where you want your VM instance to be deployed."
  type        = string
  default     = "us-central1-a"
}

variable "student_name" {
  description = "The name of the student, used for metadata in the VM instance."
  type        = string
  default     = "Mister Majestik"
}
