// Global variables
variable "vpc_id" {
  description = "VPC ID"
}

variable "shared_credentials_file" {
  description = "AWS credentials file path"
}

variable "aws_profile" {
  description = "AWS profile"
}

variable "bastion_sg_id" {
  description = "Bastion Security Group"
}

variable "jenkins_sg_id" {
  description = "Jenkins Master Security Group"
}

variable "ssl_arn" {
  description = "SSL certificate"
}

variable "vpc_private_subnets" {
  description = "List of VPC private subnets"
  type        = "list"
}

variable "vpc_public_subnets" {
  description = "List of VPC Public subnets"
  type        = "list"
}

variable "iam_instance_profile" {
  description = "IAM Role with S3 access"
}

variable "swarm_discovery_bucket" {
  description = "S3 Bucket"
}

variable "hosted_zone_id" {
  description = "Route53 zone id"
}

// Default variables
variable "environment" {
  description = "Environment"
  default     = "production"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "key_name" {
  description = "SSH KeyPair"
  default     = "personal"
}

// Swarm managers

variable "manager_instance_type" {
  description = "Manager instance type"
  default     = "t2.small"
}

variable "min_managers" {
  description = "The minimum size of the auto scale group"
  default     = "3"
}

variable "max_managers" {
  description = "The maximum size of the auto scale group"
  default     = "3"
}

// Swarm workers

variable "worker_instance_type" {
  description = "Worker instance type"
  default     = "t2.medium"
}

variable "min_workers" {
  description = "The minimum size of the auto scale group"
  default     = "5"
}

variable "max_workers" {
  description = "The maximum size of the auto scale group"
  default     = "9"
}
