# Week 4 — Infrastructure as Code with Terraform

This project demonstrates Infrastructure as Code using Terraform, Docker
and AWS.

## Labs

### Week 4A — Local Docker Infrastructure

Provisioned an Nginx container, Docker image and network using Terraform.

Concepts:

- Terraform providers
- Resources
- Variables
- Outputs
- Plan and apply
- Idempotency
- Destroy and cleanup

### Week 4B — AWS Read-Only Safety Lab

Connected Terraform to AWS without creating infrastructure.

Safety controls:

- Temporary AWS CLI login credentials
- Explicit AWS Region
- Allowed AWS account ID
- Read-only data sources
- Format, validate, plan and apply workflow

### Week 4C — AWS VPC Foundations

Provisioned and verified:

- One VPC
- One private subnet
- One private route table
- Route-table association
- Private-workload security group
- VPC-only egress rule

Security decisions:

- No internet gateway
- No NAT gateway
- No automatic public IP addresses
- No inbound security-group rules
- Egress restricted to the VPC CIDR
- Consistent Terraform tags

The infrastructure was verified through Terraform and the AWS CLI before
being safely destroyed.

### Week 4D — Secure Remote State

Created a dedicated S3 backend with:

- S3 Block Public Access
- Bucket-owner-enforced object ownership
- Server-side encryption
- Bucket versioning
- HTTPS-only bucket policy
- S3 state locking
- Backend configuration kept outside Git

## Terraform Safety Pipeline

```text
terraform fmt
      ↓
terraform validate
      ↓
terraform plan
      ↓
review proposed changes
      ↓
terraform apply
      ↓
verify in Terraform and AWS
      ↓
terraform plan again
      ↓
terraform destroy when finished
