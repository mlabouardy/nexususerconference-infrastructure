// Global variables
variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-fcea7597"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "shared_credentials_file" {
  description = "AWS credentials file path"
  default     = "/Users/mlabouardy/.ssh/credentials"
}

variable "aws_profile" {
  description = "AWS profile"
  default     = "default"
}

variable "key_name" {
  description = "SSH KeyPair"
  default     = "mohamed"
}

variable "vpc_private_subnets" {
  description = "List of VPC private subnets"
  default     = ["subnet-b20759d9", "subnet-fd31a580", "subnet-2593fc68"]
}

variable "vpc_public_subnets" {
  description = "List of VPC Public subnets"
  default     = ["subnet-2b2f7c40", "subnet-c6f971bb", "subnet-f694fbbb"]
}

variable "hosted_zone_id" {
  description = "foxapi.xyz route53 zone id"
  default     = "Z38HXJ134RGEV6"
}

variable "ssl_arn" {
  description = "Foxapi SSL certificate"
  default     = "arn:aws:acm:eu-central-1:770795456108:certificate/2fce9c39-ea68-4b1a-b135-bc61e1de1350"
}

// Jenkins Master

variable "jenkins_master_image_id" {
  description = "Jenkins Master AMI"
  default     = "ami-f37e5a18"
}

variable "jenkins_master_instance_type" {
  description = "Jenkins Master instance type"
  default     = "t2.large"
}

variable "bastion_sg_id" {}
variable "jenkins_username" {}
variable "jenkins_password" {}
variable "jenkins_credentials_id" {}

// Jenkins Slaves

variable "jenkins_slave_image_id" {
  description = "Jenkins Slave AMI"
  default     = "ami-827f5b69"
}

variable "jenkins_slave_instance_type" {
  description = "Jenkins Slave instance type"
  default     = "t2.micro"
}

variable "min_jenkins_slaves" {
  description = "Min slaves"
  default     = "3"
}

variable "max_jenkins_slaves" {
  description = "Max slaves"
  default     = "5"
}

variable "jenkins_slaves_iam_role" {
  description = "IAM role to access ECR"
  default     = "AccessFoxECR"
}
