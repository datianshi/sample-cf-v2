resource "aws_elb" "cfrouter" {
  name = "cfrouter"
  subnets = ["${aws_subnet.PcfVpcPublicSubnet_az1.id}"]
  security_groups = ["${aws_security_group.cfrouter.id}"]

  listener {
    instance_port = 8080
    instance_protocol = "TCP"
    lb_port = 80
    lb_protocol = "TCP"
  }
  health_check {
    target = "TCP:8080"
    timeout = 5
    interval = 30
    unhealthy_threshold = 2
    healthy_threshold = 10
  }
  tags {
    Name = "${var.environment}-cfrouter-Elb"
  }
}
