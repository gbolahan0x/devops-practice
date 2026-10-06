variable "aws_region" {
  description = "AWS Region for the Week 6 resources."
  type        = string
  default     = "eu-west-1"
}

variable "aws_account_id" {
  description = "Safety lock restricting Terraform to the expected AWS account."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must contain exactly 12 digits."
  }
}

variable "github_owner" {
  description = "GitHub account or organization that owns the repository."
  type        = string
  default     = "gbolahan0x"
}

variable "github_owner_id" {
  description = "Numeric GitHub ID of the repository owner."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+$", var.github_owner_id))
    error_message = "github_owner_id must contain only digits."
  }
}

variable "github_repository" {
  description = "GitHub repository trusted by the AWS IAM role."
  type        = string
  default     = "devops-practice"
}

variable "github_repository_id" {
  description = "Numeric GitHub repository ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+$", var.github_repository_id))
    error_message = "github_repository_id must contain only digits."
  }
}

variable "github_branch" {
  description = "GitHub branch permitted to assume the AWS role."
  type        = string
  default     = "main"
}

variable "ecr_repository_name" {
  description = "Name of the private ECR repository."
  type        = string
  default     = "devops-zero-to-hero/week3-app"
}

variable "create_github_oidc_provider" {
  description = "Create the GitHub OIDC provider. Set false if it already exists."
  type        = bool
  default     = true
}
