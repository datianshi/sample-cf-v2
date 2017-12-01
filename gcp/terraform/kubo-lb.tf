// Static IP address for HTTP forwarding rule
resource "google_compute_address" "kubo-tcp" {
  name = "kubo"
}

// TCP Load Balancer
resource "google_compute_target_pool" "kubo-tcp-public" {
    region = "${var.region}"
    name = "kubo-tcp-public"
}

resource "google_compute_forwarding_rule" "kubo-tcp" {
  name        = "kubo-tcp"
  target      = "${google_compute_target_pool.kubo-tcp-public.self_link}"
  port_range  = "8443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.kubo-tcp.address}"
}

resource "google_compute_health_check" "kubo" {
  name = "kubo"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "8443"
  }
}

resource "google_compute_firewall" "kubo-tcp-public" {
  name    = "kubo-tcp-public"
  network       = "${var.cf_network}"

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }

  target_tags = ["master"]
}

# // Allow access to CloudFoundry HTTP router
# resource "google_compute_firewall" "kubo-services" {
#   name    = "kubo-services"
#   network       = "${var.cf_network}"
#
#   allow {
#     protocol = "tcp"
#     ports    = ["32322"]
#   }
#
#   target_tags = ["worker"]
# }
