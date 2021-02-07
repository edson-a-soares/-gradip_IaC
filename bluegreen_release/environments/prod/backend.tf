terraform {
  backend "s3" {
    encrypt = true
    region  = "us-east-1"
    profile = "secondary"
    bucket  = "bluegreen.terraform"
    key     = "releases/terraform.tfstate"
    shared_credentials_file = "~/.aws/credentials"
  }
}
