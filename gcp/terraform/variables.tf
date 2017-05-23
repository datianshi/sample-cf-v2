// Easier mainteance for updating GCE image string

variable "cfdomain" {}

variable "latest_ubuntu" {
    type = "string"
    default = "ubuntu-1404-trusty-v20161109"
}

variable "projectid" {
    type = "string"
}

variable "region" {
    type = "string"
    default = "us-east1"
}

variable "zone" {
    type = "string"
    default = "us-east1-d"
}

variable "prefix" {
    type = "string"
    default = ""
}

variable "service_account_email" {
    type = "string"
    default = ""
}

variable "baseip" {
    type = "string"
    default = "10.0.0.0"
}

variable "region_compilation" {
    type = "string"
    default = "us-central1"
}

variable "zone_compilation" {
    type = "string"
    default = "us-central1-b"
}

variable "cf_network" {
    type = "string"
    default = "bosh"
}
