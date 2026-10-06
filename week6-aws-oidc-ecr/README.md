# Week 6 — Secure Container Delivery to Amazon ECR

This project extends the Week 5 continuous-integration pipeline with secure
container-image delivery to Amazon ECR.

## Flow

```text
Push to main
   ↓
Week 5 CI passes
   ↓
GitHub requests an OIDC identity token
   ↓
AWS validates repository and branch claims
   ↓
AWS issues temporary role credentials
   ↓
Docker image is built
   ↓
Image is tagged with the Git commit SHA
   ↓
Image is pushed to private Amazon ECR
