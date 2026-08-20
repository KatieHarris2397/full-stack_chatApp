# Nexlayer — full-stack_chatApp

<!-- nexlayer:meta version=1 analyzed=2026-08-20T20:50:44Z repo=https://github.com/KatieHarris2397/full-stack_chatApp branch=main -->

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
This is a full-stack real-time chat application with a React/TailwindCSS frontend, a Node.js/Express backend using Socket.io for real-time messaging, and MongoDB for data persistence. It includes JWT-based authentication, profile management, and online status features, with Docker Compose for local development and Kubernetes planned for orchestration.
<!-- nexlayer:end -->

## Technology Stack
<!-- nexlayer:section agent-managed=tech_stack -->
| Name | Kind | Version | Detected From |
|------|------|---------|---------------|
| Node.js | language | 14+ | README.md, package.json |
| Express | framework | latest | README.md |
| React | framework | latest | README.md |
| TailwindCSS | framework | latest | README.md |
| Socket.io | framework | latest | README.md |
| MongoDB | database | latest | docker-compose.yml |
| Docker | infra | latest | docker-compose.yml |
| Nginx | infra | latest | README.md |
| Zustand | framework | latest | README.md |
| JWT | tool | latest | README.md |
| DaisyUI | framework | latest | README.md |
<!-- nexlayer:end -->

## Repository Structure
<!-- nexlayer:section agent-managed=structure_map -->
- frontend/ — React frontend with Dockerfile
- backend/ — Node.js/Express backend with Dockerfile
- k8s/ — Kubernetes manifests (planned)
- docker-compose.yml — local orchestration
- package.json — root scripts for build/start
<!-- nexlayer:end -->

## External Services Required
<!-- nexlayer:section agent-managed=external_deps -->
Services that must be configured separately (not deployed by Nexlayer):

- MongoDB (mongo:latest) — database service
- Socket.io — real-time communication
- JWT — authentication
<!-- nexlayer:end -->

## Local Development Setup
<!-- nexlayer:section user-editable=local_setup -->
### Prerequisites

- Node.js >= 14
- Docker
- Git

### Environment variables

Copy `.env.example` to `.env.local` and fill in:

```
MONGO_INITDB_ROOT_USERNAME=root
MONGO_INITDB_ROOT_PASSWORD=admin
BACKEND_URL=http://backend:5001
```

### Steps

1. `docker-compose up --build` — Build and start all services (frontend, backend, mongo)
2. `npm run build` — Install dependencies and build frontend (alternative)
3. `npm start` — Start backend only (alternative)

<!-- nexlayer:end -->

## Nexlayer Setup
<!-- nexlayer:section agent-managed=nexlayer_setup -->
### Pod Environment Variables

| Pod | Variable | Value | Kind |
|-----|----------|-------|------|
| `app` | `NODE_ENV` | `"production"` | plain |
| `app` | `PORT` | `"8080"` | plain |
| `app` | `HOSTNAME` | `"0.0.0.0"` | plain |
| `app` | `MONGODB_URI` | `"mongodb://root:${MONGO_INITDB_ROOT_PASSWORD}@mongodb.pod:27017/chat?authSource=admin"` | inter-pod |
| `mongodb` | `MONGO_INITDB_ROOT_USERNAME` | `"root"` | plain |
| `mongodb` | `MONGO_INITDB_ROOT_PASSWORD` | `"${MONGO_INITDB_ROOT_PASSWORD}"` | inter-pod |
| `backend` | `NODE_ENV` | `production` | plain |
| `backend` | `PORT` | `"5001"` | plain |
| `backend` | `MONGO_INITDB_ROOT_USERNAME` | `root` | plain |
| `backend` | `MONGO_INITDB_ROOT_PASSWORD` | `"${MONGO_INITDB_ROOT_PASSWORD}"` | inter-pod |
| `backend` | `BACKEND_URL` | `"http://backend.pod:5001"` | plain |
| `db` | `MONGO_INITDB_ROOT_USERNAME` | `root` | plain |
| `db` | `MONGO_INITDB_ROOT_PASSWORD` | `"${MONGO_INITDB_ROOT_PASSWORD}"` | inter-pod |
| `full-stack-chatapp-mongodb-data` | `size` | `10Gi` | plain |
| `full-stack-chatapp-mongodb-data` | `mountPath` | `/data/db` | plain |

### nexlayer.yaml

```yaml
application:
  name: full-stack-chatapp
  pods:
    - name: app
      image: "registry.nexlayer.io/user_01krc1n44dd49btzyv6vht92v2/full-stack-chatapp:a020ee8-fix1"
      path: /
      servicePorts:
        - 8080
      vars:
        NODE_ENV: "production"
        PORT: "8080"
        HOSTNAME: "0.0.0.0"
        MONGODB_URI: "mongodb://root:${MONGO_INITDB_ROOT_PASSWORD}@mongodb.pod:27017/chat?authSource=admin"
    - name: mongodb
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars:
        MONGO_INITDB_ROOT_USERNAME: "root"
        MONGO_INITDB_ROOT_PASSWORD: "${MONGO_INITDB_ROOT_PASSWORD}"

    - name: backend
      image: "registry.nexlayer.io/user_01krc1n44dd49btzyv6vht92v2/full-stack-chatapp:a020ee8-fix1"
      servicePorts:
        - 5001
      vars:
        NODE_ENV: production
        PORT: "5001"
        MONGO_INITDB_ROOT_USERNAME: root
        MONGO_INITDB_ROOT_PASSWORD: "${MONGO_INITDB_ROOT_PASSWORD}"
        BACKEND_URL: "http://backend.pod:5001"
    - name: db
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars:
        MONGO_INITDB_ROOT_USERNAME: root
        MONGO_INITDB_ROOT_PASSWORD: "${MONGO_INITDB_ROOT_PASSWORD}"
      volumes:
        - name: full-stack-chatapp-mongodb-data
          size: 10Gi
          mountPath: /data/db
```

<!-- nexlayer:end -->

## Nexlayer Deployment Plan
<!-- nexlayer:section user-editable=deployment_plan -->
### Pod Topology

| Pod | Image | Port | Role |
|-----|-------|------|------|
| frontend | mirror.gcr.io/library/nginx:alpine | 80 | web |
| backend | mirror.gcr.io/library/node:22-alpine | 5001 | web |
| db | mirror.gcr.io/library/mongo:latest | 27017 | database |

### Deployment notes

- Frontend pod reaches backend via backend.pod:5001 (not localhost or backend:5001).
- Backend pod reaches MongoDB via db.pod:27017 (not localhost or mongo:27017).
- Each service runs in its own pod; no co-located daemons.
- Use mirror.gcr.io/library/nginx:alpine for frontend static serving (official Docker Hub image).
- MongoDB is a separate database pod, never co-located with the app.

<!-- nexlayer:end -->

## Build Notes
<!-- nexlayer:section user-editable=build_notes -->
<!-- Add notes for future builds here — preserved across re-analysis -->
<!-- nexlayer:end -->

## Nexlayer Configuration
<!-- nexlayer:section agent-managed=nexlayer_config -->
**Last deployed:** 2026-08-20T20:57:55Z  
**Live URL:** https://xenial-tern-full-stack-chatapp.qa.cluster.vibeship.work  
**Runtime:** node · **Port:** 5001  
**Deploy branch:** main  

```yaml
application:
  name: full-stack-chatapp
  pods:
    - name: app
      image: "registry.nexlayer.io/user_01krc1n44dd49btzyv6vht92v2/full-stack-chatapp:a020ee8-fix1"
      path: /
      servicePorts:
        - 8080
      vars:
        NODE_ENV: "production"
        PORT: "8080"
        HOSTNAME: "0.0.0.0"
        MONGODB_URI: "mongodb://root:${MONGO_INITDB_ROOT_PASSWORD}@mongodb.pod:27017/chat?authSource=admin"
    - name: mongodb
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars:
        MONGO_INITDB_ROOT_USERNAME: "root"
        MONGO_INITDB_ROOT_PASSWORD: "${MONGO_INITDB_ROOT_PASSWORD}"

    - name: backend
      image: "registry.nexlayer.io/user_01krc1n44dd49btzyv6vht92v2/full-stack-chatapp:a020ee8-fix1"
      servicePorts:
        - 5001
      vars:
        NODE_ENV: production
        PORT: "5001"
        MONGO_INITDB_ROOT_USERNAME: root
        MONGO_INITDB_ROOT_PASSWORD: "${MONGO_INITDB_ROOT_PASSWORD}"
        BACKEND_URL: "http://backend.pod:5001"
    - name: db
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars:
        MONGO_INITDB_ROOT_USERNAME: root
        MONGO_INITDB_ROOT_PASSWORD: "${MONGO_INITDB_ROOT_PASSWORD}"
      volumes:
        - name: full-stack-chatapp-mongodb-data
          size: 10Gi
          mountPath: /data/db
```
<!-- nexlayer:end -->

## Build History
<!-- nexlayer:section agent-managed=build_history -->
| Date | Status | Notes |
|------|--------|-------|
| 2026-08-20T20:50:44Z | analyzed | initial repo analysis |
| 2026-08-20T20:57:55Z | success | deployed https://xenial-tern-full-stack-chatapp.qa.cluster.vibeship.work |
<!-- nexlayer:end -->
