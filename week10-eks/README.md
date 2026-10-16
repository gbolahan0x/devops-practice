# Week 10 — Managed Kubernetes with Amazon EKS

This lab moves the Week 3 Node.js application from a local kind cluster to
Amazon Elastic Kubernetes Service.

Terraform provisions the AWS infrastructure. Kubernetes manifests deploy the
application. Amazon ECR stores the immutable container image.

## Architecture

```text
Developer laptop
      |
AWS IAM authentication
      |
Restricted EKS API endpoint
      |
Amazon EKS managed control plane
      |
Managed EC2 node group
      |
Kubernetes Deployment
      |
Two application Pods
      |
ClusterIP Service
      |
kubectl port-forward
```

## AWS infrastructure

Terraform creates:

- One VPC
- Two public subnets across different Availability Zones
- One internet gateway
- One public route table
- One EKS control plane
- One managed EC2 node group
- Separate cluster and node IAM roles
- One EKS administrator access entry
- CloudWatch control-plane logging
- S3 remote Terraform state

## Kubernetes resources

Kustomize deploys:

- Namespace
- ConfigMap
- Deployment
- Two application Pods
- ClusterIP Service
- Startup, readiness and liveness probes
- CPU and memory requests and limits
- Non-root container security settings

## Security decisions

- Terraform is restricted to the expected AWS account.
- EKS API access is restricted to one learner `/32` public IP.
- The cluster creator is not silently granted permanent administrator access.
- Access is managed through an explicit EKS access entry.
- Worker nodes receive only the managed policies needed to join EKS, pull from
  ECR and provide VPC CNI networking.
- The application runs as a non-root user.
- Linux capabilities are dropped.
- The container image uses an immutable Git SHA tag.

## Cost controls

This learning environment deliberately avoids:

- NAT Gateways
- AWS Load Balancers
- Multiple worker nodes
- Warm pools
- Provisioned EKS control-plane tiers

The lab still creates billable EKS, EC2, EBS, public IPv4 and CloudWatch
resources. Destroy the environment after collecting evidence.

## Important difference from kind

With kind, both the cluster and worker nodes run locally in Docker.

With EKS:

- AWS manages the Kubernetes control plane.
- EC2 provides the worker node.
- ECR stores the application image.
- IAM authenticates the human administrator and AWS services.
- The Amazon VPC CNI assigns VPC addresses to Pods.
- Terraform state is stored remotely in S3.

## Verification

```bash
./scripts/verify.sh
./scripts/evidence.sh
```

## Cleanup

Delete the Kubernetes application before destroying the AWS infrastructure:

```bash
kubectl delete -k k8s

cd terraform
tfaws plan -destroy -out=week10-destroy.tfplan
tfaws apply week10-destroy.tfplan
```

## Skills demonstrated

- Amazon EKS
- Kubernetes
- Terraform
- Amazon VPC
- IAM roles and EKS access entries
- Amazon ECR
- CloudWatch logging
- Kustomize
- Health probes
- Resource requests and limits
- Infrastructure verification and cleanup
