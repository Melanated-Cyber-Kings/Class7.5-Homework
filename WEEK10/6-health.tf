#COLOMBIA
resource "google_compute_health_check" "colombia_health_check" {
  name               = "colombia-health-check"
  check_interval_sec = 10
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/healthz"
  }
}

#THAILAND
resource "google_compute_health_check" "thailand_health_check" {
  name               = "thailand-health-check"
  check_interval_sec = 10
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/healthz"
  }
}