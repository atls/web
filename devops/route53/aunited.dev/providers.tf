terraform {
  backend "s3" {
    bucket = "aunited-tf-state"
    key    = "route53/aunited.dev/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}
