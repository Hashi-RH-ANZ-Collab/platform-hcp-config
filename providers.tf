terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    hcp = {
      source = "hashicorp/hcp"
      version = "~> 0.106.0"
    }
  }
}

provider "hcp" {
  project_id    = var.hcp_project_id
}

provider "aws" {
  region = var.aws_region
}