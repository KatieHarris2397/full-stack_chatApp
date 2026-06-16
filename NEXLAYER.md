# Nexlayer — full-stack_chatApp

<!-- nexlayer:meta version=1 analyzed=2026-06-16T20:31:10Z repo=https://github.com/KatieHarris2397/full-stack_chatApp branch=main -->

> **For AI agents (Claude Code, Cursor, Gemini CLI, Copilot):**
> This file is the **project context** for this Nexlayer deployment — tech stack, env vars, secrets, live URL.
> For full platform detail (nexlayer.yaml schema, Dockerfile rules, CI/CD, task recipes) read **`nexlayer.skills`** in this repo.
>
> **Critical rules (full detail in `nexlayer.skills`):**
> - Inter-pod refs: `${podName:port}` only — never `localhost` or bare hostnames
> - Docker Hub images: prefix with `mirror.gcr.io/library/` — bare tags fail on the cluster
> - Secrets: set in the Nexlayer dashboard — never commit to `nexlayer.yaml` or Dockerfile
>
> **This file:** `agent-managed` sections update automatically. `user-editable` sections (Local Development Setup, Nexlayer Deployment Plan, Build Notes) are yours — preserved across re-analysis.

## Project Summary
<!-- nexlayer:section agent-managed=project_summary -->
A real-time chat application featuring instant messaging via Socket.io, user authentication with JWT, and a modern UI built with React and TailwindCSS.
<!-- nexlayer:end -->

## Technology Stack
<!-- nexlayer:section agent-managed=tech_stack -->
| Name | Kind | Version | Detected From |
|------|------|---------|---------------|
| Node.js | language | 14+ | README.md |
| Express | framework | latest | README.md |
| React | framework | latest | README.md |
| MongoDB | database | latest | docker-compose.yml, README.md |
| Socket.io | tool | latest | README.md |
| Nginx | infra | latest | README.md |
| Docker | infra | latest | docker-compose.yml |
<!-- nexlayer:end -->

## Repository Structure
<!-- nexlayer:section agent-managed=structure_map -->
- frontend/ — React frontend with TailwindCSS and Zustand
- backend/ — Node.js/Express API and Socket.io server
- k8s/ — Kubernetes manifest files
- docker-compose.yml — Local orchestration configuration
<!-- nexlayer:end -->

## External Services Required
<!-- nexlayer:section agent-managed=external_deps -->
_No external services detected._
<!-- nexlayer:end -->

## Local Development Setup
<!-- nexlayer:section user-editable=local_setup -->
### Prerequisites

- Node.js >= 14
- Docker
- Docker Compose

### Environment variables

Copy `.env.example` to `.env.local` and fill in:

```
MONGO_INITDB_ROOT_USERNAME=root
MONGO_INITDB_ROOT_PASSWORD=admin
BACKEND_URL=http://localhost:5001
```

### Steps

1. `npm install` — Install root level dependencies
2. `npm run build` — Install backend/frontend dependencies and build frontend
3. `docker-compose up -d` — Spin up frontend, backend, and mongodb services

<!-- nexlayer:end -->

## Nexlayer Setup
<!-- nexlayer:section agent-managed=nexlayer_setup -->
### Pod Environment Variables

| Pod | Variable | Value | Kind |
|-----|----------|-------|------|
| `app` | `PORT` | `"5001"` | plain |
| `app` | `HOSTNAME` | `"0.0.0.0"` | plain |
| `app` | `NODE_ENV` | `"production"` | plain |
| `mongo` | `MONGO_INITDB_ROOT_USERNAME` | `"root"` | plain |
| `mongo` | `MONGO_INITDB_ROOT_PASSWORD` | _(set via Nexlayer dashboard)_ | secret |

### Secrets Required

Set these in the Nexlayer dashboard before deploying:

- `MONGO_INITDB_ROOT_PASSWORD` (`mongo` pod)

### nexlayer.yaml

```yaml
application:
  name: rich-vale-full-stack-chatapp
  pods:
    - name: app
      image: "# filled by pipeline"
      path: /
      servicePorts:
        - 5001
      vars:
        PORT: "5001"
        HOSTNAME: "0.0.0.0"
        NODE_ENV: "production"
    - name: mongo
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars:
        MONGO_INITDB_ROOT_USERNAME: "root"
        MONGO_INITDB_ROOT_PASSWORD: "admin"
```

<!-- nexlayer:end -->

## Nexlayer Deployment Plan
<!-- nexlayer:section user-editable=deployment_plan -->
### Pod Topology

| Pod | Image | Port | Role |
|-----|-------|------|------|
| frontend | mirror.gcr.io/library/node:22-alpine | 80 | web |
| backend | mirror.gcr.io/library/node:22-alpine | 5001 | web |
| mongo | mirror.gcr.io/library/mongo:latest | 27017 | database |

### Inter-pod environment variables

- `frontend` pod: `BACKEND_URL=http://${backend:5001}`
- `backend` pod: `MONGODB_URI=mongodb://${mongo:27017}`

### Deployment notes

- Frontend uses ${backend:5001} for API communication
- Backend uses ${mongo:27017} for database connectivity
- All official images routed through mirror.gcr.io

<!-- nexlayer:end -->

## Build Notes
<!-- nexlayer:section user-editable=build_notes -->
<!-- Add notes for future builds here — preserved across re-analysis -->
<!-- nexlayer:end -->

## Nexlayer Configuration
<!-- nexlayer:section agent-managed=nexlayer_config -->
**Last deployed:** 2026-06-16T21:07:00Z  
**Live URL:** https://kitbear-studio-rich-vale-full-stack-chatapp.cloud.nexlayer.ai  
**Runtime:** node · **Port:** 5001  
**Deploy branch:** main  

```yaml
application:
  name: rich-vale-full-stack-chatapp
  pods:
    - name: app
      image: "# filled by pipeline"
      path: /
      servicePorts:
        - 5001
      vars:
        PORT: "5001"
        HOSTNAME: "0.0.0.0"
        NODE_ENV: "production"
    - name: mongo
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars:
        MONGO_INITDB_ROOT_USERNAME: "root"
        MONGO_INITDB_ROOT_PASSWORD: "admin"
```
<!-- nexlayer:end -->

## Build History
<!-- nexlayer:section agent-managed=build_history -->
| Date | Status | Notes |
|------|--------|-------|
| 2026-06-16T20:31:10Z | analyzed | initial repo analysis |
| 2026-06-16T21:07:00Z | success | deployed https://kitbear-studio-rich-vale-full-stack-chatapp.cloud.nexlayer.ai |
<!-- nexlayer:end -->
