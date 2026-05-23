#Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "allow-http" {
    name = "${var.vpc_name}-allow-http"
    network = google_compute_network.vpc_network.self_link

    allow {
        protocol = "tcp"
        ports = ["80"]
    }

    target_tags = ["http-server"]
    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]
}

#Firewall rule to allow SSH traffic
resource "google_compute_firewall" "allow-ssh-internal" {
    name = "${var.vpc_name}-allow-ssh-internal"
    network = google_compute_network.vpc_network.self_link

    allow {
        protocol = "tcp"
        ports = ["22"]
    }

    target_tags = ["ssh-server"]
    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]
}

#Firewall rule for health checks
resource "google_compute_firewall" "allow-health-checks" {
    name = "${var.vpc_name}-allow-health-checks"
    network = google_compute_network.vpc_network.self_link

    allow {
        protocol = "tcp"
        ports = ["${var.health_check_port}"]
    }

    target_tags = ["health-check"]
    direction = "INGRESS"
    source_ranges = var.health_check_source_ranges
}
