resource "aws_instance" "nexus" {
  ami                    = "${data.aws_ami.nexus.id}"
  instance_type          = "${var.nexus_instance_type}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.nexus_sg.id}"]
  subnet_id              = "${element(var.vpc_private_subnets, 0)}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = false
  }

  tags {
    Name   = "nexus"
    Author = "mlabouardy"
    Tool   = "Terraform"
  }
}
