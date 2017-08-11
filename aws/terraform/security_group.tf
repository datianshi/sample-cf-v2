/*
  Security Group Definitions
*/

/*
  Load Balancer Security group
*/
resource "aws_security_group" "cfrouter" {
    name = "${var.environment}-cfrouter"
    description = "Allow incoming connections for cfrouter."
    vpc_id = "${aws_vpc.PcfVpc.id}"
    tags {
        Name = "${var.environment}-cfrouter"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
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
        from_port = 4443
        to_port = 4443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "cfrouter2" {
    name = "${var.environment}-cfrouter2"
    description = "Allow incoming connections for cfrouter."
    vpc_id = "${aws_vpc.vpc2.id}"
    tags {
        Name = "${var.environment}-cfrouter2"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
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
        from_port = 4443
        to_port = 4443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

/*
  Jumpbox Security group
*/
resource "aws_security_group" "jumpbox" {
    name = "${var.environment}-pcf_jumpbox_sg"
    description = "Allow incoming connections for Jumpbox."
    vpc_id = "${aws_vpc.PcfVpc.id}"
    tags {
        Name = "${var.environment}-JumpBox"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${aws_subnet.PcfVpcPublicSubnet_az1.cidr_block}", "${aws_subnet.PcfVpcPrivateSubnet_az1.cidr_block}", "${aws_subnet.public_subnet_vpc2.cidr_block}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "directorSG" {
    name = "${var.environment}-pcf_director_sg"
    description = "Allow incoming connections for Ops Manager."
    vpc_id = "${aws_vpc.PcfVpc.id}"
    tags {
        Name = "${var.environment}-Bosh Director Security Group"
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
        from_port = 25555
        to_port = 25555
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8443
        to_port = 8443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 6868
        to_port = 6868
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${aws_subnet.PcfVpcPublicSubnet_az1.cidr_block}", "${aws_subnet.PcfVpcPrivateSubnet_az1.cidr_block}", "${aws_subnet.public_subnet_vpc2.cidr_block}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "VPC2SG" {
    name = "${var.environment}-pcf_director_sg"
    description = "VPC2SG"
    vpc_id = "${aws_vpc.vpc2.id}"
    tags {
        Name = "${var.environment}-Bosh Director VPC2 SG"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${aws_vpc.PcfVpc.cidr_block}","${aws_subnet.public_subnet_vpc2.cidr_block}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

/*
  PCF VMS Security group
*/
resource "aws_security_group" "pcfSG" {
    name = "${var.environment}-pcf_vms_sg"
    description = "Allow connections between PCF VMs."
    vpc_id = "${aws_vpc.PcfVpc.id}"
    tags {
        Name = "${var.environment}-PCF VMs Security Group"
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${aws_subnet.PcfVpcPrivateSubnet_az1.cidr_block}"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}
