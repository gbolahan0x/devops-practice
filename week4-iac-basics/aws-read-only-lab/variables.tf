variable "aws_region" {
  description = "AWS Region for this lab."
  type        = string
  default     = "eu-west-1"
}

variable "aws_account_id" {
  description = "Safety lock: Terraform may only talk to this AWS account."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must contain exactly 12 digits."
  }
}