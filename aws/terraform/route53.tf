resource "aws_route53_record" "vpc1" {
  zone_id = "${var.route53_zone_id}"
  name = "*.test"
  type = "CNAME"
  ttl = "900"
  records = ["${aws_elb.cfrouter.dns_name}"]
}

resource "aws_route53_record" "vpc2" {
  zone_id = "${var.route53_zone_id}"
  name = "*.peering"
  type = "CNAME"
  ttl = "900"
  records = ["${aws_elb.cfrouter2.dns_name}"]
}
