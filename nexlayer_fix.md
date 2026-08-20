# Nexlayer working build fix

This file is the authoritative, pinned build solution for this repo. Nexlayer uses it verbatim on every run and will not override it. If a future build with this fix fails, Nexlayer appends/updates it rather than regenerating.

## Fixed Dockerfile

```dockerfile
FROM mirror.gcr.io/library/node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN NODE_OPTIONS="--max-old-space-size=4096" npm run build

FROM mirror.gcr.io/library/node:22-alpine
WORKDIR /app
COPY --from=builder /app/backend ./backend
COPY --from=builder /app/frontend/dist ./frontend/dist
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/backend/package.json ./backend/package.json
COPY --from=builder /app/backend/node_modules ./backend/node_modules
COPY --from=builder /app/frontend/package.json ./frontend/package.json
COPY --from=builder /app/frontend/node_modules ./frontend/node_modules
ENV NODE_ENV=production
ENV PORT=8080
ENV HOSTNAME=0.0.0.0
EXPOSE 8080
CMD ["node", "backend/src/index.js"]
```

## Fixed nexlayer.yaml

```yaml
application:
  name: full-stack_chatApp
  pods:
    - name: app
      image: "# filled by pipeline"
      path: /
      servicePorts:
        - 8080
      vars:
        PORT: "8080"
        HOSTNAME: "0.0.0.0"
        MONGODB_URI: "mongodb://root:admin@mongodb.pod:27017/chat?authSource=admin"
    - name: mongodb
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars:
        MONGO_INITDB_ROOT_USERNAME: "root"
        MONGO_INITDB_ROOT_PASSWORD: "admin"

    - name: mongo
      image: mirror.gcr.io/library/mongo:7
      servicePorts:
        - 27017
      vars: {}
      volumes:
        - name: mongodb-data
          size: 10Gi
          mountPath: /data/db
```
