terraform {
  required_providers {
    aws = {
      version = "= 5.83.0"
      source  = "hashicorp/aws"
    }
  }
}


provider "aws" {
  region = var.region
  default_tags {
    tags = {
      service = "gitlab-runner"
    }
  }
}
