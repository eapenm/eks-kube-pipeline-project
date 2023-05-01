terraform {
  backend "s3" {
    bucket         = "system-monitoring-tfstate-em"
    key            = "system-monitoring-app.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "system-monitoring-tf-state-lock"
  }
}

provider "aws" {
  region  = "us-east-1"
}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}


