resource "aws_route53_record" "bastion" {
  zone_id = "${var.hosted_zone_id}"
  name    = "bastion.slowcoder.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.bastion_hosts_elb.dns_name}"
    zone_id                = "${aws_elb.bastion_hosts_elb.zone_id}"
    evaluate_target_health = true
  }
}
