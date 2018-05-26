// Swarm managers resource template
data "template_file" "user_data_manager" {
  template = "${file("scripts/setup-swarm.tpl")}"

  vars {
    swarm_discovery_bucket = "${var.swarm_discovery_bucket}"
    swarm_name             = "${var.environment}"
    swarm_role             = "manager"
  }
}

// Swarm managers launch configuration
resource "aws_launch_configuration" "managers_launch_conf" {
  name                 = "managers_config_${var.environment}"
  image_id             = "${data.aws_ami.docker.id}"
  instance_type        = "${var.manager_instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.swarm.id}"]
  user_data            = "${data.template_file.user_data_manager.rendered}"
  iam_instance_profile = "${var.iam_instance_profile}"

  lifecycle {
    create_before_destroy = true
  }
}

// ASG Swarm managers
resource "aws_autoscaling_group" "managers" {
  name                 = "managers_asg_${var.environment}"
  launch_configuration = "${aws_launch_configuration.managers_launch_conf.name}"
  vpc_zone_identifier  = "${var.vpc_private_subnets}"
  load_balancers       = ["${aws_elb.swarm_viz_elb.name}"]
  min_size             = "${var.min_managers}"
  max_size             = "${var.max_managers}"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "manager_${var.environment}"
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

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }
}
