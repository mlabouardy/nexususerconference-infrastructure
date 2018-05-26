resource "aws_route53_record" "viz_elb" {
  zone_id = "${var.hosted_zone_id}"
  name    = "visualizer.${var.environment}.slowcoder.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.swarm_viz_elb.dns_name}"
    zone_id                = "${aws_elb.swarm_viz_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "demo_elb" {
  zone_id = "${var.hosted_zone_id}"
  name    = "demo.${var.environment}.slowcoder.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.swarm_demo_elb.dns_name}"
    zone_id                = "${aws_elb.swarm_demo_elb.zone_id}"
    evaluate_target_health = true
  }
}
