aws_region        = "eu-west-2"
vpc_cidr          = "10.1.0.0/16"
subnet_cidr       = "10.1.1.0/24"
availability_zone = "eu-west-2a"

instance_groups = {
  web = {
    count         = 2
    ami           = "ami-0755803bcc58ae721" # Ubuntu 22.04 LTS
    instance_type = "t2.micro"
    role          = "web"
  },
  php = {
    count         = 2
    ami           = "ami-0755803bcc58ae721" # Same AMI as web
    instance_type = "t2.micro"
    role          = "php"
  },
  db = {
    count         = 1
    ami           = "ami-0755803bcc58ae721" # Same AMI as web
    instance_type = "t2.medium"
    role          = "db"
  }
}

tags = {
  Terraform   = "true"
  Project     = "my-game"
}