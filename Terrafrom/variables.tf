variable "environment" {
  type        = string
  description = "Environment name (stage/prod)"
}

variable "aws_region" {
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  type        = string
}

variable "subnet_cidr" {
  type        = string
}

variable "availability_zone" {
  type        = string
}

variable "allowed_ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_groups" {
  type = map(object({
    count         = number
    ami           = string
    instance_type = string
    role          = string
  }))
}

variable "tags" {
  type        = map(string)
  default     = {}
}