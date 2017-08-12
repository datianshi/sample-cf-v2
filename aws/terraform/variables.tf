variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_name" {}
variable "environment" {}
variable "amis_nat" {}
variable "aws_region" {}
variable "aws_cert_arn" {}
variable "az1" {}
variable "jumpbox_ami" {}
variable "opsman_ami" {}
variable "opsman_instance_type" {}
variable "aws_account_id" {}

variable "jumpbox_instance_type" {
    description = "Instance Type for Jumpbox"
    default = "m3.large"
}
variable "nat_instance_type" {
    description = "Instance Type for NAT instances"
    default = "t2.medium"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/20"
}
/*
  Availability Zone 1
*/

variable "public_subnet_cidr_az1" {
    description = "CIDR for the Public Subnet 1"
    default = "10.0.0.0/24"
}

variable private_subnet_cidr_az1 {
    description = "CIDR for the private subnet"
    default = "10.0.1.0/24"
}

variable "public_subnet_cidr_vpc2" {
    description = "CIDR for the Public Subnet at vpc2"
    default = "192.168.0.0/24"
}

variable "nat_ip_az1" {
    default = "10.0.0.6"
}

variable "infra_subnet_cidr_az1" {
    description = "CIDR for the infrastructure"
    default = "10.0.6.0/24"
}

variable "vpc2_cidr" {
    description = "CIDR for the vpc2"
    default = "192.168.0.0/16"
}

variable "route53_zone_id" {
    description = "route 53 zone"
    default = "Z28RYDWSA0ALH7"
}
