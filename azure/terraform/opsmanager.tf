///////////////////////////////////////////////
//////// Pivotal Customer[0] //////////////////
//////// Set Ops Mgr //////////////////////////
///////////////////////////////////////////////

resource "azurerm_network_interface" "ops_manager_nic" {
  name                = "${var.env_name}-ops-manager-nic"
  location            = "${var.location}"
  resource_group_name = "${var.env_name}"

  ip_configuration {
    name                          = "${var.env_name}-ops-manager-ip-config"
    subnet_id                     = "${azurerm_subnet.opsman_and_director_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.16.231"
    public_ip_address_id          = "${azurerm_public_ip.pub_ip_id_opsman_vm.id}"
  }
}

resource "azurerm_storage_blob" "ops_manager_image" {
  name                   = "opsman.vhd"
  resource_group_name    = "${var.env_name}"
  storage_account_name   = "${azurerm_storage_account.opsmgr_storage_account.name}"
  storage_container_name = "${azurerm_storage_container.opsmgr_storage_container.name}"
  source_uri             = "https://opsmanagerwestus.blob.core.windows.net/images/ops-manager-1.10.8.vhd"
}

resource "azurerm_virtual_machine" "ops_manager_vm" {
  name                  = "${var.env_name}-ops-manager-vm"
  depends_on            = ["azurerm_network_interface.ops_manager_nic","azurerm_storage_blob.ops_manager_image"]
  location              = "${var.location}"
  resource_group_name   = "${var.env_name}"
  network_interface_ids = ["${azurerm_network_interface.ops_manager_nic.id}"]
  vm_size               = "Standard_F4s"

  storage_os_disk {
    name          = "opsman_disk.vhd"
    vhd_uri       = "${azurerm_storage_account.opsmgr_storage_account.primary_blob_endpoint}${azurerm_storage_container.opsmgr_storage_container.name}/opsman_disk.vhd"
    image_uri     = "${azurerm_storage_blob.ops_manager_image.url}"
    caching       = "ReadWrite"
    os_type       = "linux"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.env_name}-ops-manager"
    admin_username = "${var.vm_admin_username}"
    admin_password = "${var.vm_admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.vm_admin_username}/.ssh/authorized_keys"
      key_data = "${var.vm_admin_public_key}"
    }
  }
}
