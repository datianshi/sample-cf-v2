data "template_file" "strongswan_user_data" {
  template = "${file("vpn/initiate_strongswan.tpl")}"
}

variable strongswan_instance_ami {}
variable az {}
variable vpc_id {}
variable strongswan_instance_type {}
variable aws_key_name {}
variable left_subnet_cidr {}
variable internal_vpc_cidr {}
variable subnet_id {}

resource "aws_security_group" "peering" {
    name = "For VPN peering"
    description = "Allow incoming connections for VPN peering."
    vpc_id = "${var.vpc_id}"
    tags {
        Name = "vpn peering"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 943
        to_port = 943
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 4500
        to_port = 4500
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 500
        to_port = 500
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["${var.left_subnet_cidr}","${var.internal_vpc_cidr}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource aws_eip "vpn_ip" {}

resource "aws_instance" "strongswan" {
    ami = "${var.strongswan_instance_ami}"
    availability_zone = "${var.az}"
    instance_type = "${var.strongswan_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.peering.id}"]
    subnet_id = "${var.subnet_id}"
    source_dest_check = false
    user_data = "${data.template_file.strongswan_user_data.rendered}"
    root_block_device {
        volume_size = 20
    }
    tags {
        Name = "peering instance"
    }
}

resource aws_eip_association "strongswan_associate" {
  instance_id   = "${aws_instance.strongswan.id}"
  allocation_id = "${aws_eip.vpn_ip.id}"
}
