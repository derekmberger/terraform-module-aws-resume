#################
#   PROVIDERS   #
#################
provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
    }
  }
}
