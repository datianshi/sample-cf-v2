// Subnet for the private Cloud Foundry components
resource "google_compute_subnetwork" "pks_subnet" {
  name          = "${var.prefix}pks-${var.region}"
  ip_cidr_range = "10.0.5.0/24"
  network       = "${google_compute_network.bosh.self_link}"
}
