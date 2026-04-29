# Main includes VPC CIDR, network and routing information

# Create Virtual Private Cloud
# No subnetworks are defined in this VPC since the VPC has no network 
# resources (e.g. Compute Engine)

# Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network

resource "google_compute_network" "main" {
  name                    = "food-vpc"
  auto_create_subnetworks = true
}

# Set local file resource to generate a file with content of favorite food 
# retrieved from favorite_food variable.

# Reference: https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file

# Create a local file with your favorite food
resource "local_file" "favorite_food" {
  # Newline character is added to the end of the content to ensure that the file ends
  #  with a newline, which is a common convention for text files. 
  # So when you open the file with a command like `cat`, the output will
  #  be displayed correctly without any formatting issues.
  content  = "${var.favorite_food}\n"
  filename = "${path.module}/favorite_food.txt"
}
