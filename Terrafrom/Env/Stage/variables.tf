variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"  # London region
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "The availability zone for the instances"
  type        = string
  default     = "eu-west-2a"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {
    "Name"        = "ECE-Instance",
    "Environment" = "Stage"
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_groups" {
  description = "Groups of instances to be created"
  type = map(object({
    count = number
  }))
  default = {
    ece = {
      count = 2
    }
  }
}