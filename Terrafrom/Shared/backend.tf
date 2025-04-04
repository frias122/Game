terraform {
  backend "s3" {
    bucket         = "babayagaaws"
    key            = "terraform.tfstate"  # Will be overridden per workspace
    region         = "us-west-2"         # Must match your bucket's actual region
    encrypt        = true
    
    # New way to enable state locking
    dynamodb_endpoint = "https://dynamodb.us-west-2.amazonaws.com"
    use_lockfile      = true
  }
}