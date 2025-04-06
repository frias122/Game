# Required Variables
variable "environment" {
  description = "Environment name (stage/prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR block"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Allowed SSH CIDR blocks"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_groups" {
  description = "Instance groups configuration"
  type = map(object({
    count         = number
    ami           = string
    instance_type = string
    role          = string
  }))
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}