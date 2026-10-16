variable "aws_account_id" {
  description = "Safety lock restricting Terraform to the expected AWS account."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "aws_account_id must contain exactly 12 digits."
  }
}

variable "aws_region" {
  description = "AWS Region for the EKS lab."
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = "week10-dev-cluster"
}

variable "admin_principal_arn" {
  description = "IAM user or role ARN granted administrator access to this lab cluster."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:(user|role)/.+$", var.admin_principal_arn))
    error_message = "admin_principal_arn must be an IAM user or role ARN."
  }
}

variable "admin_cidr" {
  description = "Learner public IPv4 address allowed to reach the EKS API, in /32 CIDR form."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.admin_cidr)) && endswith(var.admin_cidr, "/32")
    error_message = "admin_cidr must be one IPv4 address in /32 form, such as 203.0.113.10/32."
  }
}

variable "vpc_cidr" {
  description = "CIDR range for the Week 10 VPC."
  type        = string
  default     = "10.100.0.0/16"
}

variable "node_instance_type" {
  description = "EC2 instance type used by the managed node group."
  type        = string
  default     = "t3.small"
}

variable "ecr_repository_name" {
  description = "Existing Week 6 ECR repository containing the application image."
  type        = string
  default     = "devops-zero-to-hero/week3-app"
}

variable "image_tag" {
  description = "Immutable Git SHA tag already stored in ECR."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{7,40}$", var.image_tag))
    error_message = "image_tag must be a 7-to-40-character lowercase Git SHA."
  }
}
