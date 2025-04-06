variable "environment" {
  description = "The deployment environment"
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
  description = "AWS availability zone for the subnet"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH to instances"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "instance_groups" {
  description = "Instance groups with their AMIs, types, and count"
  type = map(object({
    ami           = string
    instance_type = string
    role          = string
    count         = number
  }))
}