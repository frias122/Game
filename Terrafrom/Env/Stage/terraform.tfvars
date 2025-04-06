allowed_ssh_cidr = "0.0.0.0/0"
environment      = "stage"

instance_groups = {
  app = {
    ami           = "ami-0755803bcc58ae721"
    instance_type = "t2.micro"
    count         = 2
    role          = "app"
  },
  db = {
    ami           = "ami-0755803bcc58ae721"
    instance_type = "t2.micro"
    count         = 1
    role          = "db"
  }
}