output "cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.lab.name
}

output "service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.app.name
}

output "task_definition_arn" {
  description = "ARN of the registered ECS task definition."
  value       = aws_ecs_task_definition.app.arn
}

output "image_uri" {
  description = "Immutable ECR image deployed by ECS."
  value       = "${data.aws_ecr_repository.app.repository_url}:${var.image_tag}"
}

output "log_group_name" {
  description = "CloudWatch log group receiving application logs."
  value       = aws_cloudwatch_log_group.app.name
}

output "security_group_id" {
  description = "Security group attached to the Fargate task."
  value       = aws_security_group.app.id
}
