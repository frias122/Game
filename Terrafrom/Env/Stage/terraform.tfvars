environment        = "stage"
vpc_cidr           = "10.1.0.0/16"
subnet_cidr        = "10.1.1.0/24"
availability_zone  = "eu-west-2a"
allowed_ssh_cidr   = "0.0.0.0/0"

tags = {
  Project   = "my-game"
  Terraform = "true"
}

instance_groups = {
  web = {
    ami           = "ami-0abcdef1234567890"
    instance_type = "t2.micro"
    role          = "web"
    count         = 2
  },
  db = {
    ami           = "ami-0abcdef1234567890"
    instance_type = "t2.micro"
    role          = "db"
    count         = 1
  }
}