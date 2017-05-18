///////////////////////////////////////////////
//////// Pivotal Customer[0] //////////////////
//////// Set Azure Storage Accts //////////////
///////////////////////////////////////////////

resource "azurerm_storage_account" "bosh_root_storage_account" {
  name                = "${var.env_short_name}root"
  resource_group_name = "${var.env_name}"
  location            = "${var.location}"
  account_type        = "Premium_LRS"
}

resource "azurerm_storage_account" "jumpbox_storage_account" {
  name                = "${var.env_short_name}infra"
  resource_group_name = "${var.env_name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"
}

resource "azurerm_storage_container" "jumpbox_storage_container" {
  name                  = "jumpboxagerimage"
  depends_on            = ["azurerm_storage_account.jumpbox_storage_account"]
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.jumpbox_storage_account.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "bosh_storage_container" {
  name                  = "bosh"
  depends_on            = ["azurerm_storage_account.bosh_root_storage_account"]
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.bosh_root_storage_account.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "stemcell_storage_container" {
  name                  = "stemcell"
  depends_on            = ["azurerm_storage_account.bosh_root_storage_account"]
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.bosh_root_storage_account.name}"
  container_access_type = "blob"
}

resource "azurerm_storage_table" "stemcells_storage_table" {
  name                 = "stemcells"
  resource_group_name  = "${var.env_name}"
  storage_account_name = "${azurerm_storage_account.bosh_root_storage_account.name}"
}

resource "azurerm_storage_account" "bosh_vms_storage_account_1" {
  name                = "${var.env_short_name}${data.template_file.base_storage_account_wildcard.rendered}1"
  resource_group_name = "${var.env_name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"
}

resource "azurerm_storage_container" "bosh_storage_container_1" {
  name                  = "bosh"
  depends_on            = ["azurerm_storage_account.bosh_vms_storage_account_1"]
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.bosh_vms_storage_account_1.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "stemcell_storage_container_1" {
  name                  = "stemcell"
  depends_on            = ["azurerm_storage_account.bosh_vms_storage_account_1"]
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.bosh_vms_storage_account_1.name}"
  container_access_type = "private"
}

resource "azurerm_storage_account" "bosh_vms_storage_account_2" {
  name                = "${var.env_short_name}${data.template_file.base_storage_account_wildcard.rendered}2"
  resource_group_name = "${var.env_name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"
}

resource "azurerm_storage_container" "bosh_storage_container_2" {
  name                  = "bosh"
  depends_on            = ["azurerm_storage_account.bosh_vms_storage_account_2"]
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.bosh_vms_storage_account_2.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "stemcell_storage_container_2" {
  name                  = "stemcell"
  depends_on            = ["azurerm_storage_account.bosh_vms_storage_account_2"]
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.bosh_vms_storage_account_2.name}"
  container_access_type = "private"
}

resource "azurerm_storage_account" "bosh_vms_storage_account_3" {
  name                = "${var.env_short_name}${data.template_file.base_storage_account_wildcard.rendered}3"
  resource_group_name = "${var.env_name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"
}

resource "azurerm_storage_container" "bosh_storage_container_3" {
  name                  = "bosh"
  depends_on            = ["azurerm_storage_account.bosh_vms_storage_account_3"]
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.bosh_vms_storage_account_3.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "stemcell_storage_container_3" {
  name                  = "stemcell"
  depends_on            = ["azurerm_storage_account.bosh_vms_storage_account_3"]
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.bosh_vms_storage_account_3.name}"
  container_access_type = "private"
}
