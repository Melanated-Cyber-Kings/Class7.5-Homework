# STAGE 2: VPC FOUNDATION
# Goal:
# - Enable required APIs
# - Create custom VPC
#
# Verify:
# - Compute API enabled
# - VPC named "main" exists
#
# Screenshot required:
# - API page
# - VPC Networks page


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpc_network" {
  name                            = "thomasbell-network"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = true
}

