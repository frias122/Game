provider "aws" {
  region = "us-west-2"
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

# Create a flattened list of instances for each group
locals {
  instances = flatten([
    for group_key, group in var.instance_groups : [
      for i in range(group.count) : {
        key         = "${group_key}-${i}"
        group_key   = group_key
        instance_id = i
        ami         = group.ami
        instance_type = group.instance_type
      }
    ]
  ])
}

resource "aws_instance" "group_instances" {
  for_each = { for inst in local.instances : inst.key => inst }

  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.allow_ssh.id]

  tags = merge(var.tags, {
    "Name" = "instance-${each.value.group_key}-${each.value.instance_id}"
  })
}