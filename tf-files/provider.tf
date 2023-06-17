terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.71.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.19.1"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "github" {
  token = var.github_token
}
