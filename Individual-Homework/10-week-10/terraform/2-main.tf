# Create Virtual Private Cloud (VPC) and Subnet
resource "google_compute_network" "mephisto" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "mephisto" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.mephisto.self_link
}

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

# SSH firewall rule to troubleshoot since I have compute in prublic subnet.
resource "google_compute_firewall" "ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.mephisto.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["ssh-server"]
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"] # This should be set to [YOUR_IP_ADDRESS/32].
}

# Allow GPP health checks. Need these for Goggles GFE to work.
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

# Call startup script to install software on first boot. 
locals {
  startup_script = file("${path.root}/../scripts/startup.sh")
}

# Instance Template for the Managed Instance Group (MIG).
resource "google_compute_instance_template" "mephisto_template" {
  name_prefix = "mephisto-template-"

  machine_type = var.machine_type

  # Tags to apply firewall rules for HTTP and SSH access.
  tags = ["http-server", "ssh-server"]

  disk {
    source_image = "centos-cloud/centos-stream-10"
    auto_delete  = true
    boot         = true
    disk_size_gb = var.boot_disk_size_gb
  }

  network_interface {
    network    = google_compute_network.mephisto.self_link
    subnetwork = google_compute_subnetwork.mephisto.self_link

    # Public IP for simplicity
    access_config {}
  }

  metadata = {
    student_name = var.student_name
  }

  metadata_startup_script = local.startup_script
}

# Managed Instance Group (MIG) configuration.
resource "google_compute_region_instance_group_manager" "mephisto_mig" {
  name                      = "mephisto-mig"
  base_instance_name        = "mephisto"
  region                    = var.region
  distribution_policy_zones = var.zones

  target_size = var.mig_target_size

  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template = google_compute_instance_template.mephisto_template.self_link
  }


  auto_healing_policies {
    health_check      = google_compute_health_check.mephisto_health_check.self_link
    initial_delay_sec = 300

  }
}

# Autoscaler configuration for the MIG.
resource "google_compute_region_autoscaler" "mephisto_autoscaler" {
  name   = "mephisto-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.mephisto_mig.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}

# Health check configuration.
resource "google_compute_health_check" "mephisto_health_check" {
  name                = "mephisto-health-check"
  check_interval_sec  = 30
  timeout_sec         = 10
  healthy_threshold   = 3
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

# Set up backend service for load balancer.
resource "google_compute_backend_service" "mephisto_backend" {
  name                  = var.lb_name
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = var.backend_timeout_sec
  health_checks         = [google_compute_health_check.mephisto_health_check.self_link]
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group = google_compute_region_instance_group_manager.mephisto_mig.instance_group
  }
}

# Set up URL map.
resource "google_compute_url_map" "mephisto_url_map" {
  name            = "${var.lb_name}-url-map"
  default_service = google_compute_backend_service.mephisto_backend.self_link
}

# Set up HTTP proxy for the load balancer.
resource "google_compute_target_http_proxy" "mephisto_http_proxy" {
  name    = "${var.lb_name}-http-proxy"
  url_map = google_compute_url_map.mephisto_url_map.self_link
}

# Set up global forwarding rule for the load balancer.
resource "google_compute_global_forwarding_rule" "mephisto_forwarding_rule" {
  name                  = "${var.lb_name}-forwarding-rule"
  target                = google_compute_target_http_proxy.mephisto_http_proxy.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_protocol           = "TCP"
}