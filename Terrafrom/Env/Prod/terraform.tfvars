environment       = "prod"
aws_region        = "eu-west-2"
vpc_cidr          = "10.0.0.0/16"
subnet_cidr       = "10.0.1.0/24"
availability_zone = "eu-west-2a"
allowed_ssh_cidr  = "192.168.1.0/24"  # More restrictive in prod

instance_groups = {
  web = {
    count         = 4
    ami           = "ami-0755803bcc58ae721"
    instance_type = "t2.large"
    role          = "web"
  },
  php = {
    count         = 3
    ami           = "ami-0755803bcc58ae721"
    instance_type = "t2.medium"
    role          = "php"
  },
  db = {
    count         = 2
    ami           = "ami-0755803bcc58ae721"
    instance_type = "r5.large"
    role          = "db"
  }
}

tags = {
  Project     = "my-project"
  Owner       = "ops-team"
  CostCenter  = "54321"
  Terraform   = "true"
}