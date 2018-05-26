// Jenkins slaves resource template
data "template_file" "user_data_slave" {
  template = "${file("scripts/join-cluster.tpl")}"

  vars {
    jenkins_url            = "http://${aws_instance.jenkins_master.private_ip}:8080"
    jenkins_username       = "${var.jenkins_username}"
    jenkins_password       = "${var.jenkins_password}"
    jenkins_credentials_id = "${var.jenkins_credentials_id}"
  }
}

// Jenkins slaves launch configuration
resource "aws_launch_configuration" "jenkins_slave_launch_conf" {
  name            = "jenkins_slaves_config"
  image_id        = "${data.aws_ami.jenkins-slave.id}"
  instance_type   = "${var.jenkins_slave_instance_type}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.jenkins_slaves_sg.id}"]
  user_data       = "${data.template_file.user_data_slave.rendered}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = false
  }

  lifecycle {
    create_before_destroy = true
  }
}

// ASG Jenkins slaves
resource "aws_autoscaling_group" "jenkins_slaves" {
  name                 = "jenkins_slaves_asg"
  launch_configuration = "${aws_launch_configuration.jenkins_slave_launch_conf.name}"
  vpc_zone_identifier  = "${var.vpc_private_subnets}"
  min_size             = "${var.min_jenkins_slaves}"
  max_size             = "${var.max_jenkins_slaves}"

  depends_on = ["aws_instance.jenkins_master", "aws_elb.jenkins_elb"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "jenkins_slave"
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
