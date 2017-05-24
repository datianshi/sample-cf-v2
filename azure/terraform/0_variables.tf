///////////////////////////////////////////////
//////// Pivotal Customer[0] //////////////////
//////// Set Azure Variables //////////////////
///////////////////////////////////////////////

variable "env_name" {}

variable "env_short_name" {
  description = "Used for creating storage accounts. Must be a-z only, no longer than 10 characters"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "location" {}

variable "dns_suffix" {}

variable "ops_manager_image_uri" {}
variable "vm_admin_username" {}
variable "vm_admin_password" {}
variable "vm_admin_public_key" {}

variable "vnet_cidr" {}
variable "subnet_infra_cidr" {}
variable "subnet_ert_cidr" {}

variable another_site_gateway_ip {
  default = "50.68.20.74"
}

variable another_site_cidr {
  default = "10.0.0.0/24"
}

variable gateway_subnet_cidr {
  default = "192.168.10.0/24"
}
