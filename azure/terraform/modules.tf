module "vpn" {
  source =  "./vpn"
  another_site_gateway_ip = "${var.another_site_gateway_ip}"
  another_site_cidr = "${var.another_site_cidr}"
  gateway_subnet_cidr = "${var.gateway_subnet_cidr}"
  env_name = "${var.env_name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  location = "${azurerm_resource_group.pcf_resource_group.location}"
  virtual_network_name = "${azurerm_virtual_network.pcf_virtual_network.name}"
}
