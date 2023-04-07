terraform {
  required_version = ">1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.60.0"
    }
  }
  backend "s3" {
    bucket         = "sridharbucket006"
    key            = "ssss/hellogit"
    dynamodb_table = "terraformlock"
    region         = "us-east-1"
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}




