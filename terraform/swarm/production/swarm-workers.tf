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
  load_balancers       = ["${aws_elb.swarm_demo_elb.name}"]

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
