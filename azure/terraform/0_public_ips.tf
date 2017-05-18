///////////======================//////////////
//// Addresses      =============//////////////
///////////======================//////////////

resource "azurerm_public_ip" "tcp-lb-public-ip" {
  name                         = "tcp-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.pcf_resource_group.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_public_ip" "web-lb-public-ip" {
  name                         = "web-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.pcf_resource_group.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_public_ip" "ssh-proxy-lb-public-ip" {
  name                         = "ssh-proxy-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.pcf_resource_group.name}"
  public_ip_address_allocation = "static"
}


resource "azurerm_public_ip" "jb-public-ip" {
  name                         = "jb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.pcf_resource_group.name}"
  public_ip_address_allocation = "static"
}
