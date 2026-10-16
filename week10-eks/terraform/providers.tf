provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]

  default_tags {
    tags = {
      Project     = "devops-zero-to-hero"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Lab         = "week10"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ecr_repository" "app" {
  name = var.ecr_repository_name
}
