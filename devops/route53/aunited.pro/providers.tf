terraform {
  backend "s3" {
    bucket = "aunited-tf-state"
    key    = "common/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}
