resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "${var.env_name}-jumpbox-nic"
  location            = "${var.location}"
  resource_group_name = "${var.env_name}"

  network_security_group_id = "${azurerm_network_security_group.open-ssh.id}"

  ip_configuration {
    name                          = "${var.env_name}-jumpbox-ip-config"
    subnet_id                     = "${azurerm_subnet.opsman_and_director_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "192.168.0.4"
    public_ip_address_id          = "${azurerm_public_ip.jb-public-ip.id}"
  }
}

resource "azurerm_virtual_machine" "jumpbox_vm" {
  name                  = "${var.env_name}-jumpbox-vm"
  depends_on            = ["azurerm_network_interface.jumpbox_nic"]
  location              = "${var.location}"
  resource_group_name   = "${var.env_name}"
  network_interface_ids = ["${azurerm_network_interface.jumpbox_nic.id}"]
  vm_size               = "Standard_DS2_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "14.04.2-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "jumpbox-disk.vhd"
    vhd_uri       = "${azurerm_storage_account.jumpbox_storage_account.primary_blob_endpoint}${azurerm_storage_container.jumpbox_storage_container.name}/jumpbox-disk.vhd"
    caching       = "ReadWrite"
    os_type       = "linux"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.env_name}-jumpbox"
    admin_username = "${var.vm_admin_username}"
    admin_password = "${var.vm_admin_password}"
    custom_data = "IyEvYmluL2Jhc2gKCmFwdC1nZXQgdXBkYXRlCmFwdC1nZXQgaW5zdGFsbCAteSBidWlsZC1lc3NlbnRpYWwgemxpYmMgemxpYjFnLWRldiBydWJ5IHJ1YnktZGV2IG9wZW5zc2wgbGlieHNsdC1kZXYgbGlieG1sMi1kZXYgbGlic3NsLWRldiBsaWJyZWFkbGluZTYgbGlicmVhZGxpbmU2LWRldiBsaWJ5YW1sLWRldiBsaWJzcWxpdGUzLWRldiBzcWxpdGUzIGpxIGdpdCB1bnppcApnZW0gaW5zdGFsbCBib3NoX2NsaQo="
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.vm_admin_username}/.ssh/authorized_keys"
      key_data = "${var.vm_admin_public_key}"
    }
  }
}
