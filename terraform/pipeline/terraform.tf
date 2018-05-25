terraform {
  backend "s3" {
    encrypt = "true"
    bucket  = "terraform-state"
    region  = "us-east-1"
    key     = "jenkins/terraform.tfstate"
  }
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile                 = "${var.aws_profile}"
}
