// Global variables

variable "region" {
  description = "AWS region"
}

variable "shared_credentials_file" {
  description = "AWS credentials file path"
}

variable "aws_profile" {
  description = "AWS profile"
}

variable "bastion_sg_id" {
  description = "Bastion security group ID"
}

variable "jenkins_username" {
  description = "Jenkins username"
}

variable "jenkins_password" {
  description = "Jenkins password"
}

variable "jenkins_credentials_id" {
  description = "Slaves SSH ID"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "vpc_private_subnets" {
  description = "List of VPC private subnets"
  type        = "list"
}

variable "vpc_public_subnets" {
  description = "List of VPC Public subnets"
  type        = "list"
}

variable "hosted_zone_id" {
  description = "slowcoder.com route53 zone id"
}

variable "ssl_arn" {
  description = "SSL certificate"
}

// Default variables

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "key_name" {
  description = "SSH KeyPair"
  default     = "personal"
}

// Jenkins Master

variable "jenkins_master_instance_type" {
  description = "Jenkins Master instance type"
  default     = "t2.large"
}

// Jenkins Slaves

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

// Nexus

variable "nexus_instance_type" {
  description = "Nexus instance type"
  default     = "t2.xlarge"
}
