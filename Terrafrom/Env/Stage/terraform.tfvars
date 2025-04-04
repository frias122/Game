environment       = "stage"
aws_region        = "eu-west-2"
vpc_cidr          = "10.1.0.0/16"
subnet_cidr       = "10.1.1.0/24"
availability_zone = "eu-west-2a"
allowed_ssh_cidr  = "0.0.0.0/0"

instance_groups = {
  web = {
    count         = 2
    ami           = "ami-0755803bcc58ae721"
    instance_type = "t2.micro"
    role          = "web"
  },
  php = {
    count         = 2
    ami           = "ami-0755803bcc58ae721"
    instance_type = "t2.micro"
    role          = "php"
  },
  db = {
    count         = 1
    ami           = "ami-0755803bcc58ae721"
    instance_type = "t2.medium"
    role          = "db"
  }
}

tags = {
  Project     = "my-project"
  Owner       = "dev-team"
  CostCenter  = "12345"
  Terraform   = "true"
}