#Configure Virtual Private Cloud (VPC) and Subnet
resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_router" "nat_router" {
  name    = "${var.vpc_name}-nat-router"
  network = google_compute_network.vpc_network.self_link
  region  = var.region
}

resource "google_compute_router_nat" "nat_config" {
  name   = "${var.vpc_name}-nat-config"
  router = google_compute_router.nat_router.name
  region = var.region

  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_instance_template" "instance_template" {
    name_prefix  = var.instance_template_name
    machine_type = var.machine_type

    tags = ["http-server", "ssh-server"]

    disk {
        source_image = var.source_image
        auto_delete  = true
        boot         = true
        disk_size_gb = var.boot_disk_size_gb
    }

    network_interface {
        network = google_compute_network.vpc_network.self_link
        subnetwork = google_compute_subnetwork.subnet.self_link
    }

    metadata_startup_script = file("scripts/startup.sh")
}

resource "google_compute_instance_group_manager" "mig" {
    name               = var.mig_name
    base_instance_name = "${var.mig_name}-instance"
    target_size        = var.mig_instance_count
    zone               = "${var.region}-a"

    version {
        instance_template = google_compute_instance_template.instance_template.self_link
    }

    named_port {
        name = "http"
        port = 80
    }

    auto_healing_policies {
        health_check      = google_compute_health_check.http_health_check.self_link
        initial_delay_sec = 300
    }
}

resource "google_compute_region_autoscaler" "autoscaler" {
    name   = "${var.mig_name}-autoscaler"
    region = var.region

    target = google_compute_instance_group_manager.mig.self_link

    autoscaling_policy {
        max_replicas    = 5
        min_replicas    = 2
        cpu_utilization {
            target = 0.6
        }
    }
}

resource "google_compute_health_check" "http_health_check" {
    name               = var.health_check_name
    check_interval_sec = 10
    timeout_sec        = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2

    http_health_check {
        port = var.health_check_port
        request_path = "/"
    }
}

resource "google_compute_backend_service" "backend_service" {
    name                  = var.lb_backend_service_name
    protocol              = "HTTP"
    port_name             = "http"
    timeout_sec           = 10
    health_checks         = [google_compute_health_check.http_health_check.self_link]
    load_balancing_scheme = "EXTERNAL"

    backend {
        group = google_compute_instance_group_manager.mig.instance_group
    }
}

resource "google_compute_url_map" "url_map" {
    name            = "${var.lb_name}-url-map"
    default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
    name        = "${var.lb_name}-http-proxy"
    url_map     = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
    name       = "${var.lb_name}-http-forwarding-rule"
    target     = google_compute_target_http_proxy.http_proxy.self_link
    port_range = "80"
    load_balancing_scheme = "EXTERNAL"
    ip_protocol = "TCP"
}

resource "google_compute_global_address" "lb_ip" {
    name = "${var.lb_name}-ip"
}