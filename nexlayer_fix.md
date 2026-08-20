# Nexlayer working build fix

This file is the authoritative, pinned build solution for this repo. Nexlayer uses it verbatim on every run and will not override it. If a future build with this fix fails, Nexlayer appends/updates it rather than regenerating.

## Fixed Dockerfile

```dockerfile
FROM mirror.gcr.io/library/node:22-alpine AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN NODE_OPTIONS="--max-old-space-size=4096" npm run build

FROM mirror.gcr.io/library/node:22-alpine
WORKDIR /app
COPY --from=builder /app ./
ENV NODE_ENV=production
EXPOSE 5001
CMD ["npm", "start"]

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
        NODE_ENV: "production"
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

    - name: backend
      image: "# filled by pipeline"
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
        - name: mongodb-data
          size: 10Gi
          mountPath: /data/db
```
