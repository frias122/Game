module "stage_infra" {
  source = "../../modules/vpc_instance"

  # Required variables
  environment       = var.environment
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
  instance_groups   = var.instance_groups

  # Optional variables with defaults
  aws_region       = var.aws_region
  allowed_ssh_cidr = var.allowed_ssh_cidr
  tags             = var.tags
}