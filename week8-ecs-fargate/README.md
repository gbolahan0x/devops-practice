# Week 8 — Amazon ECS Fargate Deployment

This lab deploys the Week 3 Node.js container from a private Amazon ECR
repository to Amazon ECS using AWS Fargate.

All AWS infrastructure is managed with Terraform and stored in a remote
Amazon S3 backend.

## Delivery Flow

```text
Application source code
        ↓
GitHub Actions CI
        ↓
Docker image
        ↓
Private Amazon ECR repository
        ↓
Terraform task definition
        ↓
Amazon ECS service
        ↓
AWS Fargate task
        ↓
CloudWatch Logs
