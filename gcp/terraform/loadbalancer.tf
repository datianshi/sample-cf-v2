resource "google_compute_instance_group" "ert-http-lb" {
  name        = "http-lb"
  description = "terraform generated cf instance group that is multi-zone for http/https load balancing"
  zone        = "${var.zone}"
}

resource "google_compute_backend_service" "ert_http_lb_backend_service" {
  name        = "http-lb-backend"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false
  session_affinity = "CLIENT_IP"

  backend {
    group = "${google_compute_instance_group.ert-http-lb.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.cf.self_link}"]
}

resource "google_compute_url_map" "https_lb_url_map" {
  name            = "global-pcf"
  default_service = "${google_compute_backend_service.ert_http_lb_backend_service.self_link}"
}

resource "google_compute_target_http_proxy" "http_lb_proxy" {
  name        = "http-proxy"
  description = "Load balancing front end http"
  url_map     = "${google_compute_url_map.https_lb_url_map.self_link}"
}

resource "google_compute_target_https_proxy" "https_lb_proxy" {
  name             = "https-proxy"
  description      = "Load balancing front end https"
  url_map          = "${google_compute_url_map.https_lb_url_map.self_link}"
  ssl_certificates = ["${google_compute_ssl_certificate.ssl-cert.self_link}"]
}

resource "google_compute_ssl_certificate" "ssl-cert" {
  name        = "lb-cert"
  description = "user provided ssl private key / ssl certificate pair"
  certificate = "${var.cfsslcert}"
  private_key = "${var.cfsslkey}"
}

resource "google_compute_http_health_check" "cf" {
  name = "cf-public"

  port                = 8080
  request_path        = "/health"
  check_interval_sec  = 30
  timeout_sec         = 5
  healthy_threshold   = 10
  unhealthy_threshold = 2
}

resource "google_compute_global_forwarding_rule" "cf-http" {
  name       = "cf-lb-http"
  ip_address = "${google_compute_global_address.cf.address}"
  target     = "${google_compute_target_http_proxy.http_lb_proxy.self_link}"
  port_range = "80"
}

resource "google_compute_global_forwarding_rule" "cf-https" {
  name       = "cf-lb-https"
  ip_address = "${google_compute_global_address.cf.address}"
  target     = "${google_compute_target_https_proxy.https_lb_proxy.self_link}"
  port_range = "443"
}
