# Provide outputs to console when running successful terraform deployment.
# Reference: https://developer.hashicorp.com/terraform/language/values/outputs


output "vpc_name" {
  description = "Name of the VPC"
  value       = google_compute_network.main.name

}

output "favorite_food" {
  description = "Output showing my favorite food"
  # Used trimspace to remove any leading or trailing whitespace from the content of the file.
  # Otherwise the output end up looking like with extra spaces and EOT fields.
  value = "My favorite food is ${trimspace(local_file.favorite_food.content)}"
}
