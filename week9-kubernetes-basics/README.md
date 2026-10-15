# Week 9 — Kubernetes Fundamentals with kind

This project deploys the Week 3 Node.js container to a local Kubernetes cluster
created with kind.

The lab demonstrates declarative Kubernetes configuration, application
replication, service discovery, health probes, resource management,
self-healing, scaling, rolling updates, rollback, logging and cleanup.

## Architecture

```text
Docker Desktop
      |
kind Kubernetes cluster
      |
devops-lab namespace
      |
ClusterIP Service
      |
Deployment
      |
Two Node.js application Pods
