provider "aws" {
  region = var.region
}

# Get latest Ubuntu 22.04 AMI for eu-west-2
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    "Name" = "ece-vpc"
  })
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    "Name" = "ece-subnet"
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    "Name" = "ece-gateway"
  })
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.tags, {
    "Name" = "ece-route-table"
  })
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "instance_connect" {
  name        = "ece-instance-connect-sg"
  description = "Allow EC2 Instance Connect and SSH"
  vpc_id      = aws_vpc.main.id

  # Allow EC2 Instance Connect
  ingress {
    description = "EC2 Instance Connect"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["18.130.0.0/16", "18.200.0.0/16", "13.40.0.0/16"] # AWS EC2 Instance Connect ranges for eu-west-2
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    "Name" = "ece-instance-connect-sg"
  })
}

locals {
  instances = flatten([
    for group_key, group in var.instance_groups : [
      for i in range(group.count) : {
        key         = "${group_key}-${i}"
        group_key   = group_key
        instance_id = i
      }
    ]
  ])
}

resource "aws_instance" "ece_instances" {
  for_each = { for inst in local.instances : inst.key => inst }

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.instance_connect.id]

  # Required for EC2 Instance Connect
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(var.tags, {
    "Name" = "ece-instance-${each.value.group_key}-${each.value.instance_id}"
  })

  # Install EC2 Instance Connect
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y ec2-instance-connect
              EOF
}

output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = { for k, v in aws_instance.ece_instances : k => v.id }
}

output "instance_connect_commands" {
  description = "AWS CLI commands to connect using EC2 Instance Connect"
  value = {
    for key, instance in aws_instance.ece_instances : key => {
      command = "aws ec2-instance-connect send-ssh-public-key --region ${var.region} --instance-id ${instance.id} --instance-os-user ubuntu --ssh-public-key file://~/.ssh/id_rsa.pub && ssh ubuntu@${instance.public_ip}"
    }
  }
}