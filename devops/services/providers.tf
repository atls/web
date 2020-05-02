terraform {
  backend "s3" {
    bucket = "aunited-tf-state"
    key    = "services/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    bucket = "aunited-tf-state"
    key    = "common/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config {
    bucket = "aunited-tf-state"
    key    = "infrastructure/terraform.tfstate"
    region = "eu-central-1"
  }
}
