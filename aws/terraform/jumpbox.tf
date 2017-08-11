# Create Jump box instance

data "template_file" "jumpbox_user_data" {
  template = "${file("jumpbox_custom_data.txt")}"
}

resource "aws_instance" "jumpbox" {
    ami = "${var.jumpbox_ami}"
    availability_zone = "${var.az1}"
    instance_type = "${var.jumpbox_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.jumpbox.id}"]
    subnet_id = "${aws_subnet.PcfVpcPublicSubnet_az1.id}"
    associate_public_ip_address = true
    user_data = "${data.template_file.jumpbox_user_data.rendered}"
    root_block_device {
        volume_size = 100
    }
    tags {
        Name = "${var.environment}-Jumpbox"
    }
}

resource "aws_instance" "jumpbox_2" {
    ami = "${var.jumpbox_ami}"
    availability_zone = "${var.az1}"
    instance_type = "${var.jumpbox_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.VPC2SG.id}"]
    subnet_id = "${aws_subnet.public_subnet_vpc2.id}"
    associate_public_ip_address = true
    private_ip = "192.168.0.5"
    user_data = "${data.template_file.jumpbox_user_data.rendered}"
    root_block_device {
        volume_size = 100
    }
    tags {
        Name = "${var.environment}-Jumpbox2"
    }
}

resource "aws_instance" "opsmman_vpc1" {
    ami = "${var.opsman_ami}"
    availability_zone = "${var.az1}"
    instance_type = "${var.opsman_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.directorSG.id}"]
    subnet_id = "${aws_subnet.PcfVpcPublicSubnet_az1.id}"
    associate_public_ip_address = true
    root_block_device {
        volume_size = 100
    }
    tags {
        Name = "OpsMan vpc1"
    }
}
