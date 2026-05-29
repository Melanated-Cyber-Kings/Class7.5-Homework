# This file holds all SSL certificate related code.

# Domain name was obtained manually following GCP documentation
# Reference: https://docs.cloud.google.com/domains/docs/register-domain

# Create google managed SSL certificate.
# Reference: https://docs.cloud.google.com/certificate-manager/docs/deploy-google-managed-lb-auth#terraform
locals {
  domain = var.domain_name
}

# We will use DNS authorization for the SSL certificate.
resource "google_certificate_manager_dns_authorization" "mephisto_dns_auth" {
  name        = "mephisto-dns-auth"
  description = "DNS authorization for ${local.domain}"
  domain      = local.domain

  labels = {
    "terraform" : true
  }
}

# Request certificate from GCP certificate manager. 
resource "google_certificate_manager_certificate" "mephisto_ssl_cert" {
  name        = "mephisto-rootcert"
  description = "Certificate Manager provided SSL certificate for ${local.domain}"
  managed {
    domains = ["*.${local.domain}"]

    dns_authorizations = [google_certificate_manager_dns_authorization.mephisto_dns_auth.id]

  }



  labels = {
    "terraform" : true
  }

}

# Create certificate map to link the cert to the load balancer.
resource "google_certificate_manager_certificate_map" "mephisto_cert_map" {
  name        = "mephisto-cert-map"
  description = "${local.domain} certificate map"
  labels = {
    "terraform" : true
  }
}

# Create a certificate map entry. Will use a wildcard domain 
# to allow more flexibility.

resource "google_certificate_manager_certificate_map_entry" "mephisto_cert_map_entry" {
  name        = "mephisto-cert-map-entry"
  description = "example certificate map entry"
  map         = google_certificate_manager_certificate_map.mephisto_cert_map.name
  labels = {
    "terraform" : true
  }
  certificates = [google_certificate_manager_certificate.mephisto_ssl_cert.id]
  hostname     = "*.${local.domain}"
}

# Attach the certificate map to the load balancer.
# Reference https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy
# I commented this out as it is already in main.tf

# resource "google_compute_target_https_proxy" "mephisto_https_proxy" {
#   name             = "${var.lb_name}-https-proxy" 
#     url_map          = google_compute_url_map.mephisto_url_map.self_link  
#     ssl_certificates = [google_certificate_manager_certificate.mephisto_ssl_cert.self_link]
# }