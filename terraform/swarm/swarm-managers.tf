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
    value               = "nexus-user-conference"
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

// Scale out
resource "aws_cloudwatch_metric_alarm" "high-cpu-swarm-managers-alarm" {
  alarm_name          = "high-cpu-swarm-managers-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.managers.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale-out-swarm-managers.arn}"]
}

resource "aws_autoscaling_policy" "scale-out-swarm-managers" {
  name                   = "scale-out-swarm-managers"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.managers.name}"
}

// Scale In
resource "aws_cloudwatch_metric_alarm" "low-cpu-swarm-managers-alarm" {
  alarm_name          = "low-cpu-swarm-managers-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.managers.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale-in-swarm-managers.arn}"]
}

resource "aws_autoscaling_policy" "scale-in-swarm-managers" {
  name                   = "scale-in-swarm-managers"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.managers.name}"
}
