variable "aws_account_id" {
  description = "Safety lock restricting Terraform to the expected AWS account."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must contain exactly 12 digits."
  }
}

variable "aws_region" {
  description = "AWS Region for the ECS Fargate lab."
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "ecr_repository_name" {
  description = "Existing Week 6 ECR repository."
  type        = string
  default     = "devops-zero-to-hero/week3-app"
}

variable "image_tag" {
  description = "Immutable Git commit SHA image tag from ECR."
  type        = string

  validation {
    condition     = length(var.image_tag) >= 7
    error_message = "image_tag must contain a valid Git commit SHA image tag."
  }
}

variable "allowed_cidr" {
  description = "IPv4 CIDR permitted to reach the application."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.allowed_cidr))
    error_message = "allowed_cidr must be a valid IPv4 CIDR, such as 203.0.113.10/32."
  }
}

variable "vpc_cidr" {
  description = "CIDR range for the Week 8 VPC."
  type        = string
  default     = "10.80.0.0/16"
}
