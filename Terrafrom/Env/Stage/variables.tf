variable "environment" {
  description = "The deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH to instances"
  type        = string
}

variable "instance_groups" {
  description = "Map of instance groups with their configurations"
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
}