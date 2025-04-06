provider "aws" {
  region = "us-west-2"
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

variable "instance_groups" {
  description = "Groups of instances to be created"
  type = map(object({
    ami           = string
    instance_type = string
    count         = number
  }))
  default = {
    web = {
      ami           = "ami-0755803bcc58ae721"
      instance_type = "t2.micro"
      count         = 2
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    "Name" = "main-vpc"
  })
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(var.tags, {
    "Name" = "main-subnet"
  })
}

resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  tags = merge(var.tags, {
    "Name" = "allow-ssh"
  })
}

resource "aws_instance" "group_instances" {
  for_each = var.instance_groups

  ami           = each.value.ami
  instance_type = each.value.instance_type
  count         = each.value.count
  subnet_id     = aws_subnet.main.id
  security_group = aws_security_group.allow_ssh.id

  tags = merge(var.tags, {
    "Name" = "instance-${each.key}"
  })
}
