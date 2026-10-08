provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]

  default_tags {
    tags = {
      Project     = "devops-zero-to-hero"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Lab         = "week8"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ecr_repository" "app" {
  name = var.ecr_repository_name
}

locals {
  name_prefix = "week8-${var.environment}"

  public_subnets = {
    public_a = {
      cidr = "10.80.1.0/24"
      az   = data.aws_availability_zones.available.names[0]
    }

    public_b = {
      cidr = "10.80.2.0/24"
      az   = data.aws_availability_zones.available.names[1]
    }
  }
}
