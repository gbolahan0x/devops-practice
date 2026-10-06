output "ecr_repository_name" {
  description = "Name of the private ECR repository."
  value       = aws_ecr_repository.app.name
}

output "ecr_repository_url" {
  description = "URL used when tagging and pushing Docker images."
  value       = aws_ecr_repository.app.repository_url
}

output "github_ecr_push_role_arn" {
  description = "IAM role assumed by GitHub Actions through OIDC."
  value       = aws_iam_role.github_ecr_push.arn
}

output "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC identity provider."
  value       = local.github_oidc_provider_arn
}
