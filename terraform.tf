terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project = "sw-maestro"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias = "verginia"

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project = "sw-maestro"
    }
  }
}