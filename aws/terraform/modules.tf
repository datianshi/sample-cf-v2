module "vpn" {
  source =  "./vpn"
  vpc_id = "${aws_vpc.PcfVpc.id}"
  az = "${var.az1}"
  strongswan_instance_ami = "ami-7c22b41c"
  strongswan_instance_type = "m3.medium"
  aws_key_name = "${var.aws_key_name}"
  left_subnet_cidr = "192.168.0.0/16"
  internal_vpc_cidr= "10.0.0.0/16"
  subnet_id = "${aws_subnet.PcfVpcPublicSubnet_az1.id}"
}
