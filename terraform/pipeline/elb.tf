// Chronograf ELB
resource "aws_elb" "jenkins_elb" {
  subnets                   = ["${var.vpc_public_subnets}"]
  cross_zone_load_balancing = true
  security_groups           = ["${aws_security_group.elb_jenkins_sg.id}"]
  instances                 = ["${aws_instance.jenkins_master.id}"]

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.ssl_arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 5
  }

  tags {
    Name   = "jenkins_elb"
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}
