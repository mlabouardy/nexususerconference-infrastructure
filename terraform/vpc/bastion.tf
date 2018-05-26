// Bastion host launch configuration
resource "aws_launch_configuration" "bastion_conf" {
  name            = "bastion_${var.vpc_name}"
  image_id        = "${data.aws_ami.bastion.id}"
  instance_type   = "${var.bastion_instance_type}"
  key_name        = "${var.bastion_key_name}"
  security_groups = ["${aws_security_group.bastion_host.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

// Bastion ASG
resource "aws_autoscaling_group" "bastion_asg" {
  name                 = "bastion_asg_${var.vpc_name}"
  launch_configuration = "${aws_launch_configuration.bastion_conf.name}"
  vpc_zone_identifier  = ["${aws_subnet.public_subnets.*.id}"]
  load_balancers       = ["${aws_elb.bastion_hosts_elb.name}"]
  min_size             = 1
  max_size             = 1

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "bastion_${var.vpc_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Author"
    value               = "mlabouardy"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tool"
    value               = "Terraform"
    propagate_at_launch = true
  }
}
