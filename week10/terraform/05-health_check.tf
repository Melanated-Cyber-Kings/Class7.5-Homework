resource "google_compute_region_health_check" "autohealing" {
  name               = "${local.project}-health-check"
  description        = "${local.project}-health-check"
  region             = local.region
  check_interval_sec = 10
  timeout_sec        = 5

  http_health_check {
    request_path = "/healthz"
    port         = "80"
  }


  log_config {
    enable = true
  }
}