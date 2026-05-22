module "gce-lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 14.0"

  project     = local.project
  name        = "${var.project-name}-http-lb"
  target_tags = ["http-server"]
  backends = {
    default = {
      port        = var.service_port
      protocol    = "HTTP"
      port_name   = var.service_port_name
      timeout_sec = 10
      enable_cdn  = false


      health_check = {
        request_path = "/"
        port         = var.service_port
      }

      log_config = {
        enable      = false
        sample_rate = null
      }

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group = google_compute_region_instance_group_manager.mig.instance_group
        },
      ]

      iap_config = {
        enable = false
      }
    }
  }
}