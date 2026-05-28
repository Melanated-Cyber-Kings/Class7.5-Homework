# Code was getting too complex to troubleshoot or even read
# so had to move firewall rules to a separate file.

# Firewall rule to allow HTTP traffic.
resource "google_compute_firewall" "http" {
  name    = "${var.vpc_name}-allow-http"
  network = google_compute_network.mephisto.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http-server"]
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}

/* # Uncomment this block if VM has public IP address. 
# SSH firewall rule to troubleshoot since I have compute in public subnet.

# Obtain public IP address of the machine running terraform.

# Pull data from public IP address of the machine.
# Reference: https://developer.hashicorp.com/terraform/language/data-sources/http
data "http" "client_workstation_ip" {
  url = "https://api.ipify.org?format=text"
}

# Filter the IP address to identify the IP address of the machine
# running terraform and add /32.
locals {
  client_ip_cidr = "${chomp(data.http.client_workstation_ip.response_body)}/32"
}


resource "google_compute_firewall" "ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.mephisto.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh-server"]
  direction   = "INGRESS"
  # source_ranges = ["0.0.0.0/0"] # This should be set to [YOUR_IP_ADDRESS/32].
  # Restricted SSH access to only be the machine running terraform.
  source_ranges = [local.client_ip_cidr]
}
*/

# Ran into issue with GCP console SSH. Found out GCP uses internal IP range
# for SSH instead of external IP range.
# Reference: https://docs.cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule

resource "google_compute_firewall" "ssh_internal" {
  name    = "${var.vpc_name}-allow-ssh-internal"
  network = google_compute_network.mephisto.self_link


  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["ssh-server"]
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]
}

# Allow gcp health checks. Need these for Goggles GFE to work.
resource "google_compute_firewall" "health_check" {
  name    = "${var.vpc_name}-allow-health-check"
  network = google_compute_network.mephisto.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http-server"]
  direction     = "INGRESS"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}