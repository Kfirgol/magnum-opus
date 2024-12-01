terraform {
  backend "s3" {
    bucket         = "terraform-state-commit-eks"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true                    # Encrypt the state file at rest
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Terraform = "true"
      project = "magnum-opus"
    }
  }
}
