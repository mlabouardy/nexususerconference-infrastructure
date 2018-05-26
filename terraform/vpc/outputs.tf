output "VPC ID" {
  value = "${aws_vpc.default.id}"
}

output "Public Subnets" {
  value = "${aws_subnet.public_subnets.*.cidr_block}"
}

output "Private Subnets" {
  value = "${aws_subnet.private_subnets.*.cidr_block}"
}

output "Bastion DNS" {
  value = "${aws_route53_record.bastion.name}"
}
