output "vpc_id" {
  description = "ID of the Week 4C VPC."
  value       = aws_vpc.lab.id
}

output "private_subnet_id" {
  description = "ID of the private subnet."
  value       = aws_subnet.private_a.id
}

output "private_route_table_id" {
  description = "ID of the private route table."
  value       = aws_route_table.private.id
}

output "security_group_id" {
  description = "ID of the private workload security group."
  value       = aws_security_group.private_workload.id
}

output "availability_zone" {
  description = "Availability Zone selected for the private subnet."
  value       = aws_subnet.private_a.availability_zone
}

output "public_ip_auto_assign" {
  description = "Confirms that automatic public IPv4 assignment is disabled."
  value       = aws_subnet.private_a.map_public_ip_on_launch
}
