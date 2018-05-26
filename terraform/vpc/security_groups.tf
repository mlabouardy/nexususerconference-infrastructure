resource "aws_security_group" "bastion_elb" {
  name        = "bastion_elb_sg_${var.vpc_name}"
  description = "Allow SSH from ELB SG"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name   = "bastion_elb_sg_${var.vpc_name}"
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}

resource "aws_security_group" "bastion_host" {
  name        = "bastion_sg_${var.vpc_name}"
  description = "Allow SSH from ELB SG"
  vpc_id      = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion_elb.id}"]
  }

  tags {
    Name   = "bastion_sg_${var.vpc_name}"
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}
