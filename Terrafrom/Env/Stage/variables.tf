variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for Subnet"
  type        = string
}

variable "instance_groups" {
  description = "Groups of instances to be created"
  type = map(object({
    ami           = string
    instance_type = string
    count         = number
  }))
}
