data "aws_ami" "docker" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["docker-17.12.1-ce"]
  }
}
