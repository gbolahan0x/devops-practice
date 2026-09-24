output "authenticated_principal" {
  description = "IAM identity Terraform used."
  value       = data.aws_caller_identity.current.arn
}

output "selected_region" {
  description = "AWS Region Terraform is using."
  value       = data.aws_region.current.region
}