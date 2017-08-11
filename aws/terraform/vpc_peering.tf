resource "aws_vpc_peering_connection" "provider_tenant" {
  peer_owner_id = "${var.aws_account_id}"
  peer_vpc_id   = "${aws_vpc.PcfVpc.id}"
  vpc_id        = "${aws_vpc.vpc2.id}"
  auto_accept   = true

  tags {
    Name = "VPC Peering provider and tenant network"
  }
}
