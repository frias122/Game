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
  default     = "us-west-2a"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block to allow SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {
    "Name" = "MyInstance"
  }
}
