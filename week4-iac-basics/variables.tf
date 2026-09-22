variable "environment" {
  description = "Deployment environment used in Terraform-managed resource names."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "host_port" {
  description = "Host port that exposes the Nginx service."
  type        = number
  default     = 8082

  validation {
    condition     = var.host_port >= 1024 && var.host_port <= 65535
    error_message = "host_port must be between 1024 and 65535."
  }
}
