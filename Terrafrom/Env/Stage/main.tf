provider "aws" {
  region = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for Subnet"
  type        = string
  default     = "10.1.1.0/24"
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

  tags = {
    "Name"        = "stage-vpc"
    "Environment" = "stage"
    "Project"     = "my-game"
  }
}

resource "aws_subnet" "main" {
  cidr_block = var.subnet_cidr
  vpc_id     = aws_vpc.main.id
  availability_zone = "eu-west-2a"

  tags = {
    "Name"        = "stage-subnet"
    "Environment" = "stage"
    "Project"     = "my-game"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "stage-allow-ssh"
  description = "Allow SSH inbound traffic for stage"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"        = "stage-allow-ssh"
    "Environment" = "stage"
    "Project"     = "my-game"
  }
}

resource "aws_instance" "group_instances" {
  for_each = var.instance_groups

  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = aws_subnet.main.id
  security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    "Name"        = "instance-${each.key}"
    "Environment" = "stage"
    "Project"     = "my-game"
  }
}
