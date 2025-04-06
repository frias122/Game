resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { 
    Name        = "${var.environment}-vpc",
    Environment = var.environment
  })
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone
  tags              = merge(var.tags, { 
    Name        = "${var.environment}-subnet",
    Environment = var.environment
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { 
    Name        = "${var.environment}-igw",
    Environment = var.environment
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, { 
    Name        = "${var.environment}-public-rt",
    Environment = var.environment
  })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.environment}-allow-ssh"
  description = "Allow SSH inbound traffic for ${var.environment}"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { 
    Name        = "${var.environment}-allow-ssh",
    Environment = var.environment
  })
}

resource "aws_instance" "group_instances" {
  for_each = {
    for group_key, group in var.instance_groups :
    for i in range(group.count) :
    "${group_key}-${i}" => {
      ami           = group.ami
      instance_type = group.instance_type
      role          = group.role
      index         = i
    }
  }

  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  tags = merge(var.tags, {
    Name        = "${var.environment}-${each.value.role}-${each.value.index + 1}"
    Environment = var.environment
    Role        = each.value.role
  })

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }
}