terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "env:/${terraform.workspace}/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}