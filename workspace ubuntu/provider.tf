terraform {
    required_version = "> 1.0.0"
    
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.60.0"
    }
  }
  backend "s3" {
    bucket = "sridhar8888"
    key    = "path/to/my/key"
    dynamodb_table = "sssss"
    region = "us-east-1"
  }
  }
# Configure the AWS Provider
provider "aws" {
  region = var.region
}