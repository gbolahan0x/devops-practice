output "service_url" {
  description = "URL for the Terraform-managed local Nginx service."
  value       = "http://localhost:${var.host_port}"
}

output "container_name" {
  description = "Name of the Terraform-managed Nginx container."
  value       = docker_container.nginx.name
}
