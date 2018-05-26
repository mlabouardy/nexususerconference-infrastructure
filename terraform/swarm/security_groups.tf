resource "aws_security_group" "elb_viz_sg" {
  name        = "elb_viz_sg_${var.environment}"
  description = "Allow traffic on https"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "elb_viz_sg_${var.environment}"
    Author      = "mlabouardy"
    Tool        = "Terraform"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "elb_demo_sg" {
  name        = "elb_demo_sg_${var.environment}"
  description = "Allow traffic on https"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "elb_demo_sg_${var.environment}"
    Author      = "mlabouardy"
    Tool        = "Terraform"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "swarm" {
  name        = "swarm_sg_${var.environment}"
  description = "Allow TCP: 2377,7946,2375,22,8080 UDP: 7946,4789"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${var.bastion_sg_id}", "${var.jenkins_sg_id}"]
  }

  ingress {
    from_port       = 3000
    to_port         = "3000"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb_demo_sg.id}"]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb_viz_sg.id}"]
  }

  ingress {
    from_port   = "2377"
    to_port     = "2377"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port   = "2375"
    to_port     = "2375"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port   = "7946"
    to_port     = "7946"
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port   = "7946"
    to_port     = "7946"
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port   = "4789"
    to_port     = "4789"
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "swarm_sg_${var.environment}"
    Author      = "mlabouardy"
    Tool        = "Terraform"
    Environment = "${var.environment}"
  }
}
