variable another_site_gateway_ip {
  default = "50.68.20.74"
}

variable another_site_cidr {
  default = "10.0.0.0/24"
}

variable gateway_subnet_cidr {
  default = "192.168.10.0/24"
}

variable env_name {}
variable location {}
variable resource_group_name {}
variable virtual_network_name {}

resource "azurerm_local_network_gateway" "onpremise" {
  name                = "onpremise"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  gateway_address     = "${var.another_site_gateway_ip}"
  address_space       = ["${var.another_site_cidr}"]
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${var.env_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefix       = "${var.gateway_subnet_cidr}"
}

resource "azurerm_public_ip" "vpn-public-ip" {
  name                         = "vpn-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "dynamic"
}
