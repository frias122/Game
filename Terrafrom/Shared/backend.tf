terraform {
  backend "s3" {
    bucket         = "babayagaaws"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}