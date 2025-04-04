module "vpc_instances" {
  source = "../../modules/vpc_instance"

  environment       = var.environment
  aws_region        = var.aws_region
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
  allowed_ssh_cidr  = var.allowed_ssh_cidr
  instance_groups   = var.instance_groups
  tags              = var.tags
}