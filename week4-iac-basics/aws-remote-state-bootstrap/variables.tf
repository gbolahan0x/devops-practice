variable "aws_region" {
  description = "AWS Region for the Terraform state bucket."
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
