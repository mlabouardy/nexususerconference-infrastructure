// Swarm workers resource template
data "template_file" "user_data_worker" {
  template = "${file("scripts/setup-swarm.tpl")}"

  vars {
    swarm_discovery_bucket = "${var.swarm_discovery_bucket}"
    swarm_name             = "${var.environment}"
    swarm_role             = "worker"
  }
}

// Swarm workers launch configuration
resource "aws_launch_configuration" "workers_launch_conf" {
  name                 = "workers_config_${var.environment}"
  image_id             = "${data.aws_ami.docker.id}"
  instance_type        = "${var.worker_instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.swarm.id}"]
  user_data            = "${data.template_file.user_data_worker.rendered}"
  iam_instance_profile = "${var.iam_instance_profile}"

  lifecycle {
    create_before_destroy = true
  }
}

// ASG Swarm workers
resource "aws_autoscaling_group" "workers" {
  name                 = "workers_asg_${var.environment}"
  launch_configuration = "${aws_launch_configuration.workers_launch_conf.name}"
  vpc_zone_identifier  = "${var.vpc_private_subnets}"
  min_size             = "${var.min_workers}"
  max_size             = "${var.max_workers}"

  depends_on = ["aws_autoscaling_group.managers"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "worker_${var.environment}"
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
resource "aws_cloudwatch_metric_alarm" "high-cpu-swarm-workers-alarm" {
  alarm_name          = "high-cpu-swarm-workers-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.workers.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale-out-swarm-workers.arn}"]
}

resource "aws_autoscaling_policy" "scale-out-swarm-workers" {
  name                   = "scale-out-swarm-workers"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.workers.name}"
}

// Scale In
resource "aws_cloudwatch_metric_alarm" "low-cpu-swarm-workers-alarm" {
  alarm_name          = "low-cpu-swarm-workers-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.workers.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale-in-swarm-workers.arn}"]
}

resource "aws_autoscaling_policy" "scale-in-swarm-workers" {
  name                   = "scale-in-swarm-workers"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.workers.name}"
}
