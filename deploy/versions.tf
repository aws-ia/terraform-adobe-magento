terraform {
  required_version = ">= 1.0.5"
  backend "remote" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.66.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "0.8.0"
    }
  }
}
