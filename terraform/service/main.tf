terraform {
  required_providers {
    aws = {
      version = "= 5.83.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      group = "cnt"
    }
  }
}
