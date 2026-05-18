resource "google_compute_region_health_check" "autohealing" {
  name               = "mig01-health-check"
  description        = "mig01-health-check"
  region             = "us-central1"
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