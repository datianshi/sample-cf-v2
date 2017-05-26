variable another_site_gateway_ip {
  default = "50.68.20.74"
}

variable another_site_cidr {
  default = "10.0.0.0/24"
}

variable gateway_subnet_cidr {
  default = "192.168.10.0/24"
}

variable public_subnet_id {}

variable env_name {}
variable location {}
variable resource_group_name {}
variable virtual_network_name {}

variable vm_admin_username {}
variable vm_admin_password {}
variable vm_admin_public_key {}
variable env_short_name {}

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

resource "azurerm_storage_account" "natbox_storage" {
  name                = "${var.env_short_name}natstorage"
  resource_group_name = "${var.env_name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"
}

resource "azurerm_storage_container" "natbox_container" {
  name                  = "vhdsnatbox"
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.natbox_storage.name}"
  container_access_type = "private"
}


resource "azurerm_virtual_machine" "natbox_container" {
  name                  = "${var.env_name}-natbox-vm"
  depends_on            = ["azurerm_network_interface.natbox_nic"]
  location              = "${var.location}"
  resource_group_name   = "${var.env_name}"
  network_interface_ids = ["${azurerm_network_interface.natbox_nic.id}"]
  vm_size               = "Standard_DS2_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "14.04.2-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "natbox-disk.vhd"
    vhd_uri       = "${azurerm_storage_account.natbox_storage.primary_blob_endpoint}${azurerm_storage_container.natbox_container.name}/natbox-disk.vhd"
    caching       = "ReadWrite"
    os_type       = "linux"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.env_name}-natbox"
    admin_username = "${var.vm_admin_username}"
    admin_password = "${var.vm_admin_password}"
    custom_data = "IyEvYmluL2Jhc2gKCnN1ZG8gc2ggLWMgJ2VjaG8gMSA+IC9wcm9jL3N5cy9uZXQvaXB2NC9pcF9mb3J3YXJkJwpzdWRvIGlwdGFibGVzIC10IG5hdCAtQSBQT1NUUk9VVElORyAtbyBldGgwIC1qIE1BU1FVRVJBREUK"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.vm_admin_username}/.ssh/authorized_keys"
      key_data = "${var.vm_admin_public_key}"
    }
  }
 }

 resource "azurerm_network_interface" "natbox_nic" {
   name                = "${var.env_name}-natbox_nic"
   location            = "${var.location}"
   resource_group_name = "${var.env_name}"

   ip_configuration {
     name                          = "${var.env_name}-natbox-ip-config"
     subnet_id                     = "${var.public_subnet_id}"
     private_ip_address_allocation = "dynamic"
   }
 }

resource "azurerm_route_table" "nat_ert" {
  name                = "routeThroughNat"
  location            = "${var.location}"
  resource_group_name = "${var.env_name}"
}

resource "azurerm_route" "nat_ert" {
  name                = "routeThroughNat"
  resource_group_name = "${var.env_name}"
  route_table_name    = "${azurerm_route_table.nat_ert.name}"

  address_prefix = "${var.another_site_cidr}"
  next_hop_type  = "VirtualAppliance"
  next_hop_in_ip_address = "${azurerm_network_interface.natbox_nic.private_ip_address}"
}

resource "azurerm_route_table" "direct_ert" {
  name                = "routeDirect"
  location            = "${var.location}"
  resource_group_name = "${var.env_name}"
}

resource "azurerm_route" "direct_ert" {
  name                = "routeDirect"
  resource_group_name = "${var.env_name}"
  route_table_name    = "${azurerm_route_table.direct_ert.name}"

  address_prefix = "${var.another_site_cidr}"
  next_hop_type  = "VirtualNetworkGateway"
}
