# Week 4: Local Terraform Docker Lab — Design

## Purpose

Build a small, reproducible Infrastructure as Code (IaC) project for the DevOps learning portfolio. The lab teaches Terraform's normal lifecycle without cloud cost or account risk, then provides a clear foundation for a later AWS implementation.

The learner will create and manage an isolated Docker network and an Nginx web container with Terraform, verify the result locally, and remove only those Terraform-managed resources when practice is complete.

## Success criteria

- Terraform configuration is readable, reusable, and committed to Git.
- Terraform creates an isolated Docker network and a single Nginx container.
- A variable controls the environment label and a configurable host port; the default host port is `8082`, avoiding the Week 3 service on `3001`.
- Terraform prints the local URL and managed container name as outputs.
- The learner verifies the running page, Terraform state, and Docker resources.
- `terraform destroy` removes the lab resources and verification confirms they no longer exist.
- No Terraform state, real variable files, credentials, or downloaded provider files are committed.

## Architecture

```text
Official Terraform CLI container
  ├── mounts the Week 4 project at /workspace
  └── mounts the local Docker Desktop socket
             │
             ▼
       Terraform Docker provider
             │
      ┌──────┴─────────┐
      ▼                ▼
Docker network   Nginx container
                       │
                       ▼
             http://localhost:8082
```

Terraform runs through the already-tested official HashiCorp Docker image. The Docker socket is mounted only for the trusted local-lab Terraform commands so the Docker provider can manage Docker Desktop resources. This mount is privileged in effect and must not be used with untrusted images or arbitrary Terraform code.

## Project structure

The new Week 4 project contains these focused files:

| File | Responsibility |
| --- | --- |
| `versions.tf` | Pins Terraform compatibility and declares the Docker provider. |
| `main.tf` | Defines the named Docker network, Nginx image, and Nginx container. |
| `variables.tf` | Defines `environment` and `host_port` with safe development defaults. |
| `outputs.tf` | Prints the service URL and managed container name after apply. |
| `terraform.tfvars.example` | Shows safe, non-secret variable values without committing a real local override. |
| `.gitignore` | Excludes `.terraform/`, state files, crash logs, and real `.tfvars` files. |
| `README.md` | Explains setup, command lifecycle, verification, destroy, and interview talking points. |

Resource names use a `terraform-<environment>-` prefix. The network and container each have one clear purpose, and Terraform is the only tool used to create or destroy this lab's resources.

## Lifecycle and data flow

1. The learner runs a Terraform command in the official CLI container with the project directory and Docker socket mounted.
2. `terraform init` downloads the declared Docker provider into the local `.terraform/` directory.
3. `terraform fmt -check` and `terraform validate` check formatting and configuration validity.
4. `terraform plan` compares desired configuration with Terraform state and previews changes without creating resources.
5. `terraform apply` creates the Docker network, pulls the Nginx image if required, creates the container, and writes local state.
6. Terraform outputs the application URL. The learner opens it, runs `terraform state list`, and compares it with Docker inspection commands.
7. `terraform destroy` uses the same state to remove the container and network created by this project. The learner confirms removal with Terraform and Docker commands.

## Safety and failure handling

- The project is local-only; it has no cloud provider, cloud credentials, or billable resources.
- The default port is `8082`. If it is occupied, the learner changes the `host_port` variable, previews with `plan`, and applies the change.
- Docker Desktop must be running. If the Docker provider cannot connect, the learner checks Docker before changing Terraform configuration.
- Terraform always uses `plan` before `apply` during the learning flow. The plan is reviewed for the expected network and one Nginx container.
- `.tfstate`, `.tfstate.backup`, `.terraform/`, crash logs, and real `*.tfvars` remain local. They can describe real infrastructure and may contain sensitive data in later cloud work.
- Destroy commands target only resources recorded in this lab's Terraform state. The learner does not use broad Docker cleanup commands.
- The Docker socket mount is kept limited to commands using HashiCorp's official Terraform image and this reviewed lab configuration.

## Verification plan

The implementation and learning session must demonstrate all of the following:

1. `terraform version` confirms the CLI image works.
2. `terraform init`, `terraform fmt -check`, and `terraform validate` succeed.
3. `terraform plan` proposes the expected Docker network and one Nginx container.
4. `terraform apply` succeeds and prints the local URL.
5. Opening the URL shows the Nginx response.
6. `terraform state list` names the resources Terraform owns.
7. Docker inspection confirms the container is running on the selected port and attached to the expected network.
8. `terraform destroy` succeeds, after which state and Docker inspection confirm removal.

Portfolio evidence is the committed configuration, README, command outputs or redacted screenshots for plan/apply/verification/destroy, and Git history. The state file itself is intentionally not portfolio evidence because it stays local.

## Relationship to later AWS work

This lab establishes the portable Terraform workflow: providers, resources, variables, outputs, state, plan, apply, verification, and destroy. A later AWS project will retain that lifecycle but replace Docker resources with AWS resources such as a VPC, subnet, security group, and virtual machine. AWS work will require separate credential handling, least privilege, cost controls, and explicit cleanup.

## Out of scope

- AWS provisioning or AWS credentials.
- Kubernetes, Docker Compose changes, or changes to Week 1–3 projects.
- Persistent application data, databases, TLS, or multiple services.
- Committing generated state, real variable files, or secrets.
