# Week 3: Docker Compose

This project runs a Node.js application and PostgreSQL together with Docker Compose.

## Architecture

```text
Browser → localhost:3001 → app container → db container (PostgreSQL)
```

Compose creates a private network for the services. The application connects to PostgreSQL at `db:5432`, where `db` is the Compose service name.

## Prerequisites

- Docker Desktop running
- Docker Compose v2 or later

## Start the stack

```bash
cp .env.example .env
# Edit .env and set a local development password.
docker compose up -d --build
docker compose ps
```

Open these endpoints:

- `http://localhost:3001/health` checks whether the app is running.
- `http://localhost:3001/db-health` checks whether the app can query PostgreSQL.

## Services

- `app` is built from `app/Dockerfile`, runs as the non-root `node` user, and has an HTTP health check.
- `db` uses `postgres:16-alpine`, has a PostgreSQL readiness check, and stores data in the `postgres_data` named volume.
- `app` starts only after `db` is healthy. Both services use `restart: unless-stopped`.

The real `.env` file is ignored by Git. Commit `.env.example` only; never commit real passwords.

## Operational commands

```bash
# Show service status and health
docker compose ps

# View recent logs or follow logs in real time
docker compose logs --tail=20 app
docker compose logs -f app

# Run a command inside the running app container
docker compose exec app sh

# Query PostgreSQL inside the database container
docker compose exec db psql -U app_user -d week3_app -c "SELECT current_database(), current_user;"

# Restart just the app
docker compose restart app

# Stop and remove containers and the network; data volume remains
docker compose down
```

Avoid `docker compose down -v` unless you deliberately want to delete the local database volume.

## Interview summary

Docker Compose defines a multi-container application declaratively. In this project it provides isolated service networking, service-name DNS, environment-based configuration, startup dependencies, health checks, restart policies, and persistent database storage through a named volume.
