provider "aws" {
  region = "eu-central-1"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

terraform {
  backend "s3" {
    bucket = "aunited-tf-state"
    key    = "acme/sy/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "aunited_dev" {
  backend = "s3"

  config {
    bucket = "aunited-tf-state"
    key    = "route53/aunited.dev/terraform.tfstate"
    region = "eu-central-1"
  }
}
