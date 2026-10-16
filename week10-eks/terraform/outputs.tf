output "authenticated_principal" {
  description = "AWS principal used by Terraform."
  value       = data.aws_caller_identity.current.arn
}

output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.lab.name
}

output "cluster_version" {
  description = "Kubernetes version selected by Amazon EKS."
  value       = aws_eks_cluster.lab.version
}

output "cluster_endpoint" {
  description = "EKS Kubernetes API endpoint."
  value       = aws_eks_cluster.lab.endpoint
}

output "node_group_name" {
  description = "Name of the managed EC2 node group."
  value       = aws_eks_node_group.workers.node_group_name
}

output "ecr_repository_url" {
  description = "Existing ECR repository used by the Kubernetes Deployment."
  value       = data.aws_ecr_repository.app.repository_url
}

output "image_uri" {
  description = "Immutable ECR image URI for the Kubernetes Deployment."
  value       = "${data.aws_ecr_repository.app.repository_url}:${var.image_tag}"
}

output "update_kubeconfig_command" {
  description = "Command that configures kubectl for this EKS cluster."
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.lab.name} --alias ${aws_eks_cluster.lab.name}"
}
