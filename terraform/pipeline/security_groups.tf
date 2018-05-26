resource "aws_security_group" "jenkins_master_sg" {
  name        = "jenkins_master_sg"
  description = "Allow traffic on port 8080 and enable SSH"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = ["${var.bastion_sg_id}"]
  }

  ingress {
    from_port       = "8080"
    to_port         = "8080"
    protocol        = "tcp"
    cidr_blocks     = ["${var.vpc_cidr_block}"]
    security_groups = ["${aws_security_group.elb_jenkins_sg.id}"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name   = "jenkins_master_sg"
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}

resource "aws_security_group" "jenkins_slaves_sg" {
  name        = "jenkins_slaves_sg"
  description = "Allow traffic on port 22 from Jenkins Master SG"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jenkins_master_sg.id}", "${var.bastion_sg_id}"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name   = "jenkins_slaves_sg"
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}

resource "aws_security_group" "elb_jenkins_sg" {
  name        = "elb_jenkins_sg"
  description = "Allow https traffic"
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
    Name   = "elb_jenkins_sg"
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}

resource "aws_security_group" "nexus_sg" {
  name        = "nexus_sg"
  description = "Allow traffic on port 8081 and enable SSH"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = ["${var.bastion_sg_id}"]
  }

  ingress {
    from_port       = "8081"
    to_port         = "8081"
    protocol        = "tcp"
    cidr_blocks     = ["${var.vpc_cidr_block}"]
    security_groups = ["${aws_security_group.elb_jenkins_sg.id}"]
  }

  ingress {
    from_port       = "5000"
    to_port         = "5000"
    protocol        = "tcp"
    cidr_blocks     = ["${var.vpc_cidr_block}"]
    security_groups = ["${aws_security_group.elb_registry_sg.id}"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name   = "nexus_sg"
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}

resource "aws_security_group" "elb_nexus_sg" {
  name        = "elb_nexus_sg"
  description = "Allow https traffic"
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
    Name   = "elb_nexus_sg"
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}

resource "aws_security_group" "elb_registry_sg" {
  name        = "elb_registry_sg"
  description = "Allow https traffic"
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
    Name   = "elb_registry_sg"
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}
