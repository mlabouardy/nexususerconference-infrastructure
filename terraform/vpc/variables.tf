variable "region" {
  description = "AWS region"
}

variable "shared_credentials_file" {
  description = "AWS credentials file path"
}

variable "aws_profile" {
  description = "AWS profile"
}

variable "vpc_name" {
  description = "VPC name"
  default     = "nexus-user-conference"
}

variable "cidr_block" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = "list"
  default     = ["us-east-1a", "us-east-1b"]
  description = "List of Availability Zones"
}

variable "public_count" {
  default     = 2
  description = "Number of public subnets"
}

variable "private_count" {
  default     = 2
  description = "Number of private subnets"
}

variable "bastion_instance_type" {
  description = "Bastion Instance type"
  default     = "t2.micro"
}

variable "bastion_key_name" {
  description = "Bastion KeyName"
  default     = "personal"
}

variable "hosted_zone_id" {
  description = "slowcoder.com route53 zone id"
  default     = "Z2TR95QTU3UIUT"
}
