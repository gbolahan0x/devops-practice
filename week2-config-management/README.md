# Week 2: Containerized Configuration Management

This project generates and validates application configuration for `dev`, `staging`, and `prod` without installing Bash tooling or YAML linting dependencies on the host.

## Design

```text
environment files (read-only bind mount)
                 ↓
        config-tools container
                 ↓
generated configuration + logs (bind mounts)
```

The container image includes only the scripts, templates, Bash, and `yamllint`. Environment files are deliberately excluded from the image and mounted read-only at runtime so credentials do not become image layers.

## Run the complete environment test

```bash
docker compose --profile tools run --rm config-tools scripts/test-all-environments.sh
```

## Generate and validate one environment

```bash
docker compose --profile tools run --rm config-tools scripts/config-generator.sh staging
docker compose --profile tools run --rm config-tools scripts/validate-config.sh generated/app-config-staging.yaml
```

## Simulate a configuration-based deployment

```bash
docker compose --profile tools run --rm config-tools scripts/deploy-with-config.sh prod
```

## Key concepts

- `config-tools` is a one-off job, so it is run with `docker compose run`, not kept running with `docker compose up`.
- The `tools` profile prevents the job from starting when Compose is brought up without explicitly requesting it.
- `--rm` removes the completed job container; generated files and logs remain on the host through bind mounts.
- `./environments` is mounted with `:ro`, preventing the container from changing source environment files.

## Interview summary

I containerized the configuration-generation workflow as a repeatable job. The image packages the tooling, while environment-specific inputs are injected at runtime through a read-only mount. This avoids packaging credentials into image layers and allows the same workflow to validate development, staging, and production configurations consistently.
