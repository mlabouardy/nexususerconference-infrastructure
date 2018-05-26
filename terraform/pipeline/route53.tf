resource "aws_route53_record" "jenkins_master" {
  zone_id = "${var.hosted_zone_id}"
  name    = "jenkins.slowcoder.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.jenkins_elb.dns_name}"
    zone_id                = "${aws_elb.jenkins_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "nexus" {
  zone_id = "${var.hosted_zone_id}"
  name    = "nexus.slowcoder.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.nexus_elb.dns_name}"
    zone_id                = "${aws_elb.nexus_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "registry" {
  zone_id = "${var.hosted_zone_id}"
  name    = "registry.slowcoder.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.registry_elb.dns_name}"
    zone_id                = "${aws_elb.registry_elb.zone_id}"
    evaluate_target_health = true
  }
}
