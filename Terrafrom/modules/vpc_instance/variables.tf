variable "environment" {
  description = "The deployment environment (stage/prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "eu-west-2a"
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH to instances"
  type        = string
  default     = "0.0.0.0/0"
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
  default     = {}
}