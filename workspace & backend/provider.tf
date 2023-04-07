terraform {
  required_version = ">1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.60.0"
    }
  }
  backend "s3" {
    bucket         = "back12345678"
    key            = "ssss/hellogit"
    dynamodb_table = "back12"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

                                                                                                                                                                             