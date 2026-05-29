# DNS setup for load balancer

# Create A record in GCP Cloud DNS to point to load balancer IP address.
# Reference: https://registry.terraform.io/providers/hashicorp/google/7.26.0/docs/data-sources/dns_record_set

resource "google_dns_record_set" "mephisto_dns_record" {
  # I set the name to www.<domain name> since I requested a 
  # wildcard certificate which allows for subdomains like devops.<domain name>
  name         = "www.${var.domain_name}."
  type         = "A"
  ttl          = 300
  managed_zone = var.dns_managed_zone
  rrdatas      = [google_compute_global_address.mephisto_lb_ip.address]
}

# Create a DNS validation record for the SSL certificate.
# Create DNS validation record required by Certificate Manager.
resource "google_dns_record_set" "mephisto_cert_validation" {
  name         = google_certificate_manager_dns_authorization.mephisto_dns_auth.dns_resource_record[0].name
  type         = google_certificate_manager_dns_authorization.mephisto_dns_auth.dns_resource_record[0].type
  ttl          = 300
  managed_zone = var.dns_managed_zone

  rrdatas = [
    google_certificate_manager_dns_authorization.mephisto_dns_auth.dns_resource_record[0].data
  ]
}