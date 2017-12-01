// Subnet for the public Cloud Foundry components
resource "google_compute_subnetwork" "cf-compilation-subnet-1" {
  name          = "${var.prefix}cf-compilation-${var.region_compilation}"
  region        = "${var.region_compilation}"
  ip_cidr_range = "10.0.1.0/24"
  network       = "${google_compute_network.bosh.self_link}"

}

// Subnet for the private Cloud Foundry components
resource "google_compute_subnetwork" "cf-private-subnet-1" {
  name          = "${var.prefix}cf-private-${var.region}"
  ip_cidr_range = "192.168.0.0/16"
  network       = "${google_compute_network.bosh.self_link}"
}

// Allow access to CloudFoundry HTTP router
resource "google_compute_firewall" "cf-public" {
  name    = "${var.prefix}cf-public"
  network       = "${var.cf_network}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "2222", "4443", "8080"]
  }

  target_tags = ["cf-public", "router", "pcf-vms"]
}

// Allow access to CloudFoundry TCP router
resource "google_compute_firewall" "cf-tcp-public" {
  name    = "${var.prefix}cf-tcp-public"
  network       = "${var.cf_network}"

  allow {
    protocol = "tcp"
    ports    = ["80", "1024-1123"]
  }

  target_tags = ["cf-tcp-public"]
}

// Static IP address for HTTP forwarding rule
resource "google_compute_global_address" "cf" {
  name = "${var.prefix}cf"
}

// Static IP address for Doppler forwarding rule
resource "google_compute_address" "doppler" {
  name = "${var.prefix}doppler"
}

// Static IP address for TCP forwarding rule
resource "google_compute_address" "cf-tcp" {
  name = "${var.prefix}cf-tcp"
}

output "ip" {
    value = "${google_compute_global_address.cf.address}"
}

output "tcp_ip" {
    value = "${google_compute_address.cf-tcp.address}"
}

output "network" {
   value = "${var.cf_network}"
}

output "private_subnet" {
   value = "${google_compute_subnetwork.cf-private-subnet-1.name}"
}

output "compilation_subnet" {
   value = "${google_compute_subnetwork.cf-compilation-subnet-1.name}"
}

output "zone" {
  value = "${var.zone}"
}

output "zone_compilation" {
  value = "${var.zone_compilation}"
}

output "region" {
  value = "${var.region}"
}

output "region_compilation" {
  value = "${var.region_compilation}"
}
