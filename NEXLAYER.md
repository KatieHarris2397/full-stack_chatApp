# Nexlayer — full-stack_chatApp

<!-- nexlayer:meta version=1 analyzed=2026-06-26T15:45:01Z repo=https://github.com/KatieHarris2397/full-stack_chatApp branch=main -->

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
A real-time chat application featuring instant messaging via Socket.io, user authentication with JWT, and a modern React frontend with TailwindCSS.
<!-- nexlayer:end -->

## Technology Stack
<!-- nexlayer:section agent-managed=tech_stack -->
| Name | Kind | Version | Detected From |
|------|------|---------|---------------|
| Node.js | language | 22 | Dockerfile |
| Express | framework | latest | README.md |
| React | framework | latest | README.md |
| MongoDB | database | latest | docker-compose.yml |
| Socket.io | tool | latest | README.md |
| Nginx | infra | alpine | Dockerfile |
| TailwindCSS | tool | latest | README.md |
<!-- nexlayer:end -->

## Repository Structure
<!-- nexlayer:section agent-managed=structure_map -->
- backend/ — Node.js Express server and Socket.io logic
- frontend/ — React application source code
- k8s/ — Kubernetes orchestration manifests
- package.json — Root build scripts for orchestration
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
- MongoDB

### Environment variables

Copy `.env.example` to `.env.local` and fill in:

```
MONGO_URI=mongodb://localhost:27017/chat
JWT_SECRET=your_secret_key
BACKEND_URL=http://localhost:5001
```

### Steps

1. `npm run build` — Install dependencies for both frontend and backend and build frontend
2. `npm run start` — Start the backend server
3. `cd frontend && npm start` — Start the React development server

<!-- nexlayer:end -->

## Nexlayer Setup
<!-- nexlayer:section agent-managed=nexlayer_setup -->
### Pod Environment Variables

| Pod | Variable | Value | Kind |
|-----|----------|-------|------|
| `frontend` | `BACKEND_URL` | `"<% URL %>"` | plain |
| `backend` | `NODE_ENV` | `"production"` | plain |
| `backend` | `PORT` | `"5001"` | plain |
| `backend` | `HOSTNAME` | `"0.0.0.0"` | plain |
| `backend` | `MONGODB_URI` | `"mongodb://root:${MONGO_INITDB_ROOT_PASSWORD}@mongo.pod:27017/chat-app?authSource=admin"` | inter-pod |
| `mongo` | `MONGO_INITDB_ROOT_USERNAME` | `"root"` | plain |
| `mongo` | `MONGO_INITDB_ROOT_PASSWORD` | `"${MONGO_INITDB_ROOT_PASSWORD}"` | inter-pod |
| `full-stack-chatapp-mongodb-data` | `size` | `10Gi` | plain |
| `full-stack-chatapp-mongodb-data` | `mountPath` | `/data/db` | plain |

### nexlayer.yaml

```yaml
application:
  name: full-stack-chatapp
  pods:
    - name: frontend
      image: "registry.nexlayer.io/user_01kna6j8vrcfj9q0wjtq5qsq3n/full-stack_chatapp:19f422cdf01"
      path: /
      servicePorts:
        - 80
      vars:
        BACKEND_URL: "<% URL %>"
    - name: backend
      image: "registry.nexlayer.io/user_01kna6j8vrcfj9q0wjtq5qsq3n/full-stack_chatapp:19f422cdf01"
      servicePorts:
        - 5001
      vars:
        NODE_ENV: "production"
        PORT: "5001"
        HOSTNAME: "0.0.0.0"
        MONGODB_URI: "mongodb://root:${MONGO_INITDB_ROOT_PASSWORD}@mongo.pod:27017/chat-app?authSource=admin"
    - name: mongo
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars:
        MONGO_INITDB_ROOT_USERNAME: "root"
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
| backend | mirror.gcr.io/library/node:20-alpine | 5001 | web |
| mongo | mirror.gcr.io/library/mongo:latest | 27017 | database |

### Deployment notes

- Frontend connects to the backend via backend.pod:5001
- Backend connects to MongoDB via mongo.pod:27017
- Images are mirrored via gcr.io to comply with Nexlayer platform rules

<!-- nexlayer:end -->

## Build Notes
<!-- nexlayer:section user-editable=build_notes -->
<!-- Add notes for future builds here — preserved across re-analysis -->
<!-- nexlayer:end -->

## Nexlayer Configuration
<!-- nexlayer:section agent-managed=nexlayer_config -->
**Last deployed:** 2026-07-08T19:48:42Z  
**Live URL:** https://kitbear-studio-full-stack-chatapp.cloud.nexlayer.ai  
**Runtime:**  · **Port:** auto-detected  
**Deploy branch:** nexlayer  

```yaml
application:
  name: full-stack-chatapp
  pods:
    - name: frontend
      image: "registry.nexlayer.io/user_01kna6j8vrcfj9q0wjtq5qsq3n/full-stack_chatapp:19f422cdf01"
      path: /
      servicePorts:
        - 80
      vars:
        BACKEND_URL: "<% URL %>"
    - name: backend
      image: "registry.nexlayer.io/user_01kna6j8vrcfj9q0wjtq5qsq3n/full-stack_chatapp:19f422cdf01"
      servicePorts:
        - 5001
      vars:
        NODE_ENV: "production"
        PORT: "5001"
        HOSTNAME: "0.0.0.0"
        MONGODB_URI: "mongodb://root:${MONGO_INITDB_ROOT_PASSWORD}@mongo.pod:27017/chat-app?authSource=admin"
    - name: mongo
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars:
        MONGO_INITDB_ROOT_USERNAME: "root"
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
| 2026-07-08T19:47:40Z | analyzed | initial repo analysis |
| 2026-07-08T19:48:42Z | success | deployed https://kitbear-studio-full-stack-chatapp.cloud.nexlayer.ai |
<!-- nexlayer:end -->




