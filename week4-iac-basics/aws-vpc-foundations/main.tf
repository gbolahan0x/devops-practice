provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]

  default_tags {
    tags = {
      Project     = "devops-zero-to-hero"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Lab         = "week4c"
    }
  }
}

locals {
  name_prefix = "week4c-${var.environment}"
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "aws_vpc" "lab" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name_prefix}-private-a"
    Tier = "private"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "${local.name_prefix}-private-rt"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "private_workload" {
  name                   = "${local.name_prefix}-private-workload-sg"
  description            = "Private workload security group with no inbound access"
  vpc_id                 = aws_vpc.lab.id
  revoke_rules_on_delete = true

  tags = {
    Name = "${local.name_prefix}-private-workload-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "within_vpc" {
  security_group_id = aws_security_group.private_workload.id
  description       = "Allow outbound traffic only within the lab VPC"
  cidr_ipv4         = aws_vpc.lab.cidr_block
  ip_protocol       = "-1"
}
