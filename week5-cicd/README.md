# Week 5 — Continuous Integration with GitHub Actions

This project adds continuous integration to the DevOps practice repository.

## Pipeline

The workflow runs for pull requests, pushes to `main`, and manual workflow
dispatches.

```text
Git change
   │
   ├── Node unit test
   ├── Bash syntax validation
   ├── Terraform formatting check
   └── Docker Compose integration test
