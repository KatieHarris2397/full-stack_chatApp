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
