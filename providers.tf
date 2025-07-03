terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.30"  # You can also try 5.20 or 4.67
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
