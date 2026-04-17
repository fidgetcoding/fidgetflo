# 🚀 FidgetFlo Production Deployment Guide

## Table of Contents

- [Quick Start](#quick-start)
- [System Requirements](#system-requirements)
- [Environment Variables](#environment-variables)
- [Docker Deployment](#docker-deployment)
- [Kubernetes Deployment](#kubernetes-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Monitoring & Observability](#monitoring--observability)
- [Security Configuration](#security-configuration)
- [Load Balancing](#load-balancing)
- [Production Setup](#production-setup)
- [Cloud Deployment](#cloud-deployment)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

### Production Installation

```bash
# Install from npm registry
npm install -g fidgetflo@alpha

# Verify installation
npx fidgetflo@alpha --version

# Initialize configuration
npx fidgetflo@alpha init --force

# Test installation
npx fidgetflo@alpha swarm "test deployment" --agents 3
```

### Prerequisites Check

```bash
# Check Node.js version (requires ≥20.0.0)
node --version

# Check npm version (requires ≥9.0.0)
npm --version

# Check system resources
free -h  # Memory check
df -h    # Disk space check

# Install required tools
apt-get update && apt-get install -y curl wget jq
```

---

## System Requirements

### Production Requirements

| Component | Minimum | Recommended | Enterprise |
|-----------|---------|-------------|------------|
| Node.js | v20.0.0 | v20 LTS | v20 LTS |
| RAM | 4 GB | 8 GB | 16 GB |
| CPU | 2 cores | 4 cores | 8+ cores |
| Disk Space | 2 GB | 10 GB | 50 GB |
| Network | 100 Mbps | 1 Gbps | 10 Gbps |
| Uptime SLA | 99% | 99.9% | 99.99% |

### Operating System Support

- **Linux**: Ubuntu 20.04+, CentOS 8+, RHEL 8+, Amazon Linux 2
- **Docker**: Alpine 3.18+, Ubuntu 22.04+
- **Kubernetes**: 1.24+
- **Cloud**: AWS, GCP, Azure, DigitalOcean

### Network Requirements

```bash
# Required ports
3000/tcp   # Main API server
8080/tcp   # MCP server
5432/tcp   # PostgreSQL (if used)
6379/tcp   # Redis (if used)
9090/tcp   # Prometheus metrics
3001/tcp   # Grafana dashboard

# Outbound connections
https://api.anthropic.com    # Claude API
https://api.openai.com       # OpenAI API (optional)
https://registry.npmjs.org   # Package registry
https://github.com           # Repository access
```

---

## Environment Variables

### Production Environment Configuration

```bash
# Create production environment file
cat > .env.production << 'EOF'
# === Core Configuration ===
NODE_ENV=production
PORT=3000
HOST=0.0.0.0

# === API Keys ===
CLAUDE_API_KEY=sk-ant-api03-...
OPENAI_API_KEY=sk-...
GITHUB_TOKEN=ghp_...

# === FidgetFlo Configuration ===
FIDGETFLO_DEBUG=false
FIDGETFLO_LOG_LEVEL=info
FIDGETFLO_DATA_DIR=/app/data
FIDGETFLO_MEMORY_DIR=/app/memory
FIDGETFLO_CONFIG_DIR=/app/config

# === Performance Settings ===
FIDGETFLO_MAX_AGENTS=100
FIDGETFLO_MAX_CONCURRENT_TASKS=50
FIDGETFLO_MEMORY_LIMIT=2048
FIDGETFLO_CACHE_SIZE=512
FIDGETFLO_WORKER_THREADS=8

# === Database Configuration ===
DATABASE_URL=postgresql://claude_flow:secure_password@postgres:5432/claude_flow
REDIS_URL=redis://redis:6379/0
CACHE_TTL=3600
CONNECTION_POOL_SIZE=20

# === Security ===
JWT_SECRET=your-secure-jwt-secret-256-bits
ENCRYPTION_KEY=your-encryption-key-256-bits
ALLOWED_ORIGINS=https://yourdomain.com
RATE_LIMIT_WINDOW=900000
RATE_LIMIT_MAX=100

# === Features ===
FIDGETFLO_ENABLE_HOOKS=true
FIDGETFLO_ENABLE_MCP=true
FIDGETFLO_ENABLE_SWARM=true
FIDGETFLO_ENABLE_METRICS=true
FIDGETFLO_ENABLE_TRACING=true

# === Monitoring ===
PROMETHEUS_PORT=9090
GRAFANA_ADMIN_PASSWORD=secure-password
LOG_RETENTION_DAYS=30
METRICS_RETENTION_DAYS=90

# === Cloud Provider (AWS Example) ===
AWS_REGION=us-west-2
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
S3_BUCKET=fidgetflo-backups

# === Notifications ===
SLACK_WEBHOOK_URL=https://hooks.slack.com/...
EMAIL_SMTP_HOST=smtp.sendgrid.net
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USER=apikey
EMAIL_SMTP_PASS=SG...
EOF
```

### Configuration Validation

```bash
# Validate environment configuration
npx fidgetflo@alpha config validate --env production

# Test API connectivity
npx fidgetflo@alpha diagnostics --api-check

# Verify database connection
npx fidgetflo@alpha diagnostics --db-check
```

---

## Docker Deployment

### Production Docker Image

```dockerfile
# Production Dockerfile
FROM node:20-alpine AS base

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    sqlite \
    postgresql-client \
    redis \
    curl \
    jq

# Create app directory
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S fidgetflo -u 1001 -G nodejs

# === Build Stage ===
FROM base AS builder

# Copy package files
COPY package*.json ./
COPY tsconfig*.json ./

# Install dependencies
RUN npm ci --only=production --no-audit --no-fund

# Copy source code
COPY src/ ./src/
COPY *.js *.ts *.json ./

# Build application
RUN npm run build

# === Production Stage ===
FROM base AS production

# Set environment
ENV NODE_ENV=production \
    FIDGETFLO_DATA_DIR=/app/data \
    FIDGETFLO_MEMORY_DIR=/app/memory \
    FIDGETFLO_CONFIG_DIR=/app/config \
    FIDGETFLO_LOG_LEVEL=info

# Copy built application
COPY --from=builder --chown=fidgetflo:nodejs /app/dist ./dist
COPY --from=builder --chown=fidgetflo:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=fidgetflo:nodejs /app/package*.json ./

# Create data directories
RUN mkdir -p /app/data /app/memory /app/config /app/logs && \
    chown -R fidgetflo:nodejs /app

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose ports
EXPOSE 3000 8080 9090

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Switch to non-root user
USER fidgetflo:nodejs

# Start application
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["node", "dist/index.js"]
```

### Docker Entrypoint Script

```bash
#!/bin/sh
# docker-entrypoint.sh

set -e

# Initialize configuration if not exists
if [ ! -f "/app/config/config.json" ]; then
    echo "Initializing FidgetFlo configuration..."
    npx fidgetflo@alpha init --force --config-dir /app/config
fi

# Wait for database if DATABASE_URL is set
if [ -n "$DATABASE_URL" ]; then
    echo "Waiting for database to be ready..."
    until pg_isready -d "$DATABASE_URL" > /dev/null 2>&1; do
        echo "Database not ready, waiting..."
        sleep 2
    done
    echo "Database is ready!"
fi

# Wait for Redis if REDIS_URL is set
if [ -n "$REDIS_URL" ]; then
    echo "Waiting for Redis to be ready..."
    until redis-cli -u "$REDIS_URL" ping > /dev/null 2>&1; do
        echo "Redis not ready, waiting..."
        sleep 2
    done
    echo "Redis is ready!"
fi

# Run database migrations
if [ "$NODE_ENV" = "production" ]; then
    echo "Running database migrations..."
    npx fidgetflo@alpha db migrate
fi

# Start the application
echo "Starting FidgetFlo..."
exec "$@"
```

### Production Docker Compose

```yaml
# docker-compose.production.yml
version: '3.8'

services:
  # === Core Services ===
  fidgetflo:
    image: fidgetflo:2.0.0-production
    container_name: fidgetflo-app
    restart: unless-stopped
    ports:
      - "3000:3000"
      - "8080:8080"
    environment:
      NODE_ENV: production
      CLAUDE_API_KEY: ${CLAUDE_API_KEY}
      DATABASE_URL: postgresql://claude_flow:${DB_PASSWORD}@postgres:5432/claude_flow
      REDIS_URL: redis://redis:6379/0
      FIDGETFLO_MAX_AGENTS: 100
      FIDGETFLO_MEMORY_LIMIT: 2048
    volumes:
      - fidgetflo-data:/app/data
      - fidgetflo-memory:/app/memory
      - fidgetflo-config:/app/config
      - fidgetflo-logs:/app/logs
    networks:
      - fidgetflo-net
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s

  # === Database Services ===
  postgres:
    image: postgres:15-alpine
    container_name: fidgetflo-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: claude_flow
      POSTGRES_USER: claude_flow
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_INITDB_ARGS: "--auth-host=md5"
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
    networks:
      - fidgetflo-net
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U claude_flow -d claude_flow"]
      interval: 30s
      timeout: 10s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: fidgetflo-redis
    restart: unless-stopped
    command: redis-server --appendonly yes --maxmemory 512mb --maxmemory-policy allkeys-lru
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    networks:
      - fidgetflo-net
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3

  # === Load Balancer ===
  nginx:
    image: nginx:alpine
    container_name: fidgetflo-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/conf.d:/etc/nginx/conf.d:ro
      - ./ssl:/etc/nginx/ssl:ro
      - nginx-cache:/var/cache/nginx
    networks:
      - fidgetflo-net
    depends_on:
      - fidgetflo
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # === Monitoring Stack ===
  prometheus:
    image: prom/prometheus:latest
    container_name: fidgetflo-prometheus
    restart: unless-stopped
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus-data:/prometheus
    networks:
      - fidgetflo-net
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=90d'
      - '--web.enable-lifecycle'

  grafana:
    image: grafana/grafana:latest
    container_name: fidgetflo-grafana
    restart: unless-stopped
    ports:
      - "3001:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_ADMIN_PASSWORD}
      GF_INSTALL_PLUGINS: grafana-clock-panel,grafana-simple-json-datasource
    volumes:
      - grafana-data:/var/lib/grafana
      - ./monitoring/grafana/dashboards:/etc/grafana/provisioning/dashboards
      - ./monitoring/grafana/datasources:/etc/grafana/provisioning/datasources
    networks:
      - fidgetflo-net

  # === Backup Service ===
  backup:
    image: postgres:15-alpine
    container_name: fidgetflo-backup
    restart: "no"
    volumes:
      - ./backups:/backups
      - ./scripts/backup.sh:/backup.sh:ro
    networks:
      - fidgetflo-net
    environment:
      DATABASE_URL: postgresql://claude_flow:${DB_PASSWORD}@postgres:5432/claude_flow
    depends_on:
      - postgres
    profiles:
      - backup

volumes:
  postgres-data:
  redis-data:
  prometheus-data:
  grafana-data:
  fidgetflo-data:
  fidgetflo-memory:
  fidgetflo-config:
  fidgetflo-logs:
  nginx-cache:

networks:
  fidgetflo-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

### Building and Deployment

```bash
# Build production image
docker build -f Dockerfile.production -t fidgetflo:2.0.0-production .

# Tag for registry
docker tag fidgetflo:2.0.0-production your-registry.com/fidgetflo:2.0.0

# Push to registry
docker push your-registry.com/fidgetflo:2.0.0

# Deploy with Docker Compose
cp .env.production .env
docker-compose -f docker-compose.production.yml up -d

# View logs
docker-compose -f docker-compose.production.yml logs -f fidgetflo

# Scale services
docker-compose -f docker-compose.production.yml up -d --scale fidgetflo=3

# Health check
curl -f http://localhost/health

# Stop services
docker-compose -f docker-compose.production.yml down
```

### Docker Registry Setup

```bash
# Setup private registry (optional)
docker run -d -p 5000:5000 --name registry \
  -v /opt/docker-registry:/var/lib/registry \
  registry:2

# Build and push to private registry
docker build -t localhost:5000/fidgetflo:2.0.0 .
docker push localhost:5000/fidgetflo:2.0.0

# Pull from registry
docker pull localhost:5000/fidgetflo:2.0.0
```

---

## Docker Deployment

### Dockerfile

```dockerfile
# Multi-stage build for optimal size
FROM node:20-alpine AS builder

# Install build dependencies
RUN apk add --no-cache python3 make g++ sqlite-dev

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build application
RUN npm run build

# Production stage
FROM node:20-alpine

# Install runtime dependencies
RUN apk add --no-cache sqlite

WORKDIR /app

# Copy built application
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# Create data directories
RUN mkdir -p /data/.fidgetflo /data/.swarm /data/memory

# Set environment variables
ENV NODE_ENV=production \
    FIDGETFLO_DATA_DIR=/data/.fidgetflo \
    FIDGETFLO_MEMORY_DIR=/data/.swarm \
    PORT=3000

# Expose ports
EXPOSE 3000 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

# Run as non-root user
USER node

# Start application
CMD ["node", "dist/cli/main.js", "server"]
```

### Docker Compose

```yaml
version: '3.8'

services:
  fidgetflo:
    build: .
    image: fidgetflo:latest
    container_name: fidgetflo
    restart: unless-stopped
    ports:
      - "3000:3000"
      - "8080:8080"
    environment:
      - NODE_ENV=production
      - CLAUDE_API_KEY=${CLAUDE_API_KEY}
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - FIDGETFLO_LOG_LEVEL=info
    volumes:
      - ./data:/data
      - ./config:/app/config
      - ./logs:/app/logs
    networks:
      - fidgetflo-network
    depends_on:
      - redis
      - postgres

  redis:
    image: redis:7-alpine
    container_name: fidgetflo-redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    networks:
      - fidgetflo-network

  postgres:
    image: postgres:15-alpine
    container_name: fidgetflo-postgres
    restart: unless-stopped
    environment:
      - POSTGRES_DB=claude_flow
      - POSTGRES_USER=claude_flow
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - fidgetflo-network

  nginx:
    image: nginx:alpine
    container_name: fidgetflo-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - fidgetflo
    networks:
      - fidgetflo-network

volumes:
  redis-data:
  postgres-data:

networks:
  fidgetflo-network:
    driver: bridge
```

### Building and Running

```bash
# Build Docker image
docker build -t fidgetflo:latest .

# Run with Docker
docker run -d \
  --name fidgetflo \
  -p 3000:3000 \
  -e CLAUDE_API_KEY=$CLAUDE_API_KEY \
  -v $(pwd)/data:/data \
  fidgetflo:latest

# Run with Docker Compose
docker-compose up -d

# View logs
docker logs -f fidgetflo

# Stop container
docker stop fidgetflo

# Remove container
docker rm fidgetflo
```

#### Services and Ingress

```yaml
# k8s/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: fidgetflo-service
  namespace: fidgetflo
  labels:
    app: fidgetflo
spec:
  type: ClusterIP
  selector:
    app: fidgetflo
  ports:
  - name: http
    port: 80
    targetPort: 3000
    protocol: TCP
  - name: mcp
    port: 8080
    targetPort: 8080
    protocol: TCP
  - name: metrics
    port: 9090
    targetPort: 9090
    protocol: TCP
---
# Load Balancer Service
apiVersion: v1
kind: Service
metadata:
  name: fidgetflo-lb
  namespace: fidgetflo
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:us-west-2:123456789:certificate/..."
    service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "https"
spec:
  type: LoadBalancer
  selector:
    app: fidgetflo
  ports:
  - name: https
    port: 443
    targetPort: 3000
    protocol: TCP
  - name: http
    port: 80
    targetPort: 3000
    protocol: TCP
---
# Ingress for advanced routing
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: fidgetflo-ingress
  namespace: fidgetflo
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/rate-limit-window: "1m"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: "10m"
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
spec:
  tls:
  - hosts:
    - api.fidgetflo.com
    - mcp.fidgetflo.com
    secretName: fidgetflo-tls
  rules:
  - host: api.fidgetflo.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: fidgetflo-service
            port:
              number: 80
  - host: mcp.fidgetflo.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: fidgetflo-service
            port:
              number: 8080
```

#### Persistent Volumes and HPA

```yaml
# k8s/pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: fidgetflo-data-pvc
  namespace: fidgetflo
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
  storageClassName: gp3
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: fidgetflo-memory-pvc
  namespace: fidgetflo
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: gp3
---
# k8s/hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: fidgetflo-hpa
  namespace: fidgetflo
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: fidgetflo
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  - type: Pods
    pods:
      metric:
        name: custom_metric_requests_per_second
      target:
        type: AverageValue
        averageValue: "50"
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 60
```

#### Kubernetes Deployment Commands

```bash
# Create namespace
kubectl create namespace fidgetflo

# Apply RBAC
kubectl apply -f k8s/namespace.yaml

# Create secrets (encode values with base64)
echo -n "your-claude-api-key" | base64
kubectl create secret generic fidgetflo-secrets \
  --from-literal=claude-api-key="$(echo -n 'your-api-key' | base64)" \
  --from-literal=database-url="$(echo -n 'postgresql://...' | base64)" \
  --from-literal=jwt-secret="$(echo -n 'your-jwt-secret' | base64)" \
  -n fidgetflo

# Apply configurations
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/pvc.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/hpa.yaml

# Check deployment status
kubectl get pods -n fidgetflo -w
kubectl get svc -n fidgetflo
kubectl get ingress -n fidgetflo

# View logs
kubectl logs -f deployment/fidgetflo -n fidgetflo

# Scale deployment manually
kubectl scale deployment/fidgetflo --replicas=5 -n fidgetflo

# Rolling update
kubectl set image deployment/fidgetflo fidgetflo=your-registry.com/fidgetflo:2.0.1 -n fidgetflo
kubectl rollout status deployment/fidgetflo -n fidgetflo

# Rollback if needed
kubectl rollout undo deployment/fidgetflo -n fidgetflo

# Port forward for testing
kubectl port-forward svc/fidgetflo-service 3000:80 -n fidgetflo

# Delete deployment
kubectl delete namespace fidgetflo
```

---

## CI/CD Pipeline

### GitHub Actions Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy FidgetFlo

on:
  push:
    branches: [main, staging, production]
    tags: ['v*']
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [20]
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run linting
      run: npm run lint
    
    - name: Run type checking
      run: npm run typecheck
    
    - name: Run tests
      run: npm run test:coverage
      env:
        CLAUDE_API_KEY: ${{ secrets.CLAUDE_API_KEY }}
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3

  security-scan:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Run Snyk to check for vulnerabilities
      uses: snyk/actions/node@master
      env:
        SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
    
    - name: Run Trivy vulnerability scanner
      uses: aquasecurity/trivy-action@master
      with:
        scan-type: 'fs'
        scan-ref: '.'

  build:
    needs: [test, security-scan]
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    outputs:
      image: ${{ steps.image.outputs.image }}
      digest: ${{ steps.build.outputs.digest }}
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Docker Buildx
      uses: docker/setup-buildx-action@v3
    
    - name: Login to Container Registry
      uses: docker/login-action@v3
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=semver,pattern={{version}}
          type=semver,pattern={{major}}.{{minor}}
          type=sha,prefix=sha-
    
    - name: Build and push
      id: build
      uses: docker/build-push-action@v5
      with:
        context: .
        file: ./Dockerfile.production
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max
        platforms: linux/amd64,linux/arm64
    
    - name: Output image
      id: image
      run: |
        echo "image=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ steps.meta.outputs.version }}" >> $GITHUB_OUTPUT

  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/staging'
    environment: staging
    steps:
    - uses: actions/checkout@v4
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-west-2
    
    - name: Setup kubectl
      uses: azure/setup-kubectl@v3
      with:
        version: 'v1.28.0'
    
    - name: Update kubeconfig
      run: aws eks update-kubeconfig --region us-west-2 --name fidgetflo-staging
    
    - name: Deploy to staging
      run: |
        kubectl set image deployment/fidgetflo fidgetflo=${{ needs.build.outputs.image }} -n fidgetflo-staging
        kubectl rollout status deployment/fidgetflo -n fidgetflo-staging --timeout=300s
    
    - name: Run smoke tests
      run: |
        kubectl port-forward svc/fidgetflo-service 3000:80 -n fidgetflo-staging &
        sleep 10
        curl -f http://localhost:3000/health || exit 1
        npx fidgetflo@alpha swarm "test deployment" --agents 1 || exit 1

  deploy-production:
    needs: build
    runs-on: ubuntu-latest
    if: startsWith(github.ref, 'refs/tags/v')
    environment: production
    steps:
    - uses: actions/checkout@v4
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-west-2
    
    - name: Setup kubectl
      uses: azure/setup-kubectl@v3
    
    - name: Update kubeconfig
      run: aws eks update-kubeconfig --region us-west-2 --name fidgetflo-production
    
    - name: Deploy to production
      run: |
        # Blue-green deployment
        kubectl patch deployment fidgetflo -p '{"spec":{"template":{"spec":{"containers":[{"name":"fidgetflo","image":"${{ needs.build.outputs.image }}"}]}}}}' -n fidgetflo
        kubectl rollout status deployment/fidgetflo -n fidgetflo --timeout=600s
    
    - name: Run production tests
      run: |
        # Wait for deployment to be ready
        kubectl wait --for=condition=available --timeout=300s deployment/fidgetflo -n fidgetflo
        
        # Run health checks
        EXTERNAL_IP=$(kubectl get svc fidgetflo-lb -n fidgetflo -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
        curl -f "https://$EXTERNAL_IP/health" || exit 1
    
    - name: Notify deployment
      uses: 8398a7/action-slack@v3
      with:
        status: ${{ job.status }}
        text: "FidgetFlo ${{ github.ref_name }} deployed to production"
      env:
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### Terraform Infrastructure

```hcl
# infrastructure/main.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
  
  backend "s3" {
    bucket = "fidgetflo-terraform-state"
    key    = "production/terraform.tfstate"
    region = "us-west-2"
  }
}

# EKS Cluster
resource "aws_eks_cluster" "claude_flow" {
  name     = "fidgetflo-production"
  role_arn = aws_iam_role.cluster.arn
  version  = "1.28"

  vpc_config {
    subnet_ids              = aws_subnet.private[*].id
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

# Node Group
resource "aws_eks_node_group" "claude_flow" {
  cluster_name    = aws_eks_cluster.claude_flow.name
  node_group_name = "fidgetflo-nodes"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = aws_subnet.private[*].id
  instance_types  = ["m5.large", "m5.xlarge"]
  
  scaling_config {
    desired_size = 3
    max_size     = 20
    min_size     = 3
  }
  
  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group_AmazonEC2ContainerRegistryReadOnly,
  ]
}

# RDS Instance
resource "aws_db_instance" "claude_flow" {
  identifier             = "fidgetflo-production"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.r5.large"
  allocated_storage      = 100
  max_allocated_storage  = 1000
  
  db_name  = "claude_flow"
  username = "claude_flow"
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.claude_flow.name
  
  backup_retention_period = 30
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  performance_insights_enabled = true
  monitoring_interval         = 60
  monitoring_role_arn        = aws_iam_role.rds_enhanced_monitoring.arn
  
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "fidgetflo-final-snapshot"
  
  tags = {
    Environment = "production"
    Application = "fidgetflo"
  }
}

# ElastiCache Redis
resource "aws_elasticache_replication_group" "claude_flow" {
  replication_group_id         = "fidgetflo-redis"
  description                  = "Redis cluster for FidgetFlo"
  
  node_type                    = "cache.r6g.large"
  port                         = 6379
  parameter_group_name         = "default.redis7"
  
  num_cache_clusters           = 3
  automatic_failover_enabled   = true
  multi_az_enabled            = true
  
  subnet_group_name           = aws_elasticache_subnet_group.claude_flow.name
  security_group_ids          = [aws_security_group.redis.id]
  
  at_rest_encryption_enabled  = true
  transit_encryption_enabled  = true
  auth_token                  = var.redis_auth_token
  
  snapshot_retention_limit    = 7
  snapshot_window            = "03:00-05:00"
  
  tags = {
    Environment = "production"
    Application = "fidgetflo"
  }
}

# Application Load Balancer
resource "aws_lb" "claude_flow" {
  name               = "fidgetflo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = true
  enable_http2              = true

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    prefix  = "alb-logs"
    enabled = true
  }
}
```

---

## Monitoring & Observability

### Prometheus Configuration

```yaml
# monitoring/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'fidgetflo-production'
    environment: 'production'

rule_files:
  - "rules/*.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager:9093']

scrape_configs:
  # FidgetFlo application
  - job_name: 'fidgetflo'
    kubernetes_sd_configs:
      - role: pod
        namespaces:
          names: ['fidgetflo']
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__

  # Node Exporter
  - job_name: 'node-exporter'
    kubernetes_sd_configs:
      - role: node
    relabel_configs:
      - source_labels: [__address__]
        regex: '(.*):10250'
        replacement: '${1}:9100'
        target_label: __address__

  # PostgreSQL
  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres-exporter:9187']

  # Redis
  - job_name: 'redis'
    static_configs:
      - targets: ['redis-exporter:9121']
```

### Production Backup Strategy

```bash
#!/bin/bash
# scripts/backup.sh - Production backup script

set -euo pipefail

BACKUP_DIR="/backups/$(date +%Y/%m/%d)"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30
S3_BUCKET="fidgetflo-backups"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Database backup
echo "Starting PostgreSQL backup..."
pg_dump "$DATABASE_URL" | gzip > "$BACKUP_DIR/postgres_$DATE.sql.gz"

# Redis backup
echo "Starting Redis backup..."
redis-cli -u "$REDIS_URL" --rdb "$BACKUP_DIR/redis_$DATE.rdb"
gzip "$BACKUP_DIR/redis_$DATE.rdb"

# Configuration backup
echo "Backing up configurations..."
kubectl get secret fidgetflo-secrets -n fidgetflo -o yaml > "$BACKUP_DIR/secrets_$DATE.yaml"
kubectl get configmap fidgetflo-config -n fidgetflo -o yaml > "$BACKUP_DIR/config_$DATE.yaml"

# Application data backup
echo "Backing up application data..."
tar -czf "$BACKUP_DIR/app-data_$DATE.tar.gz" /app/data /app/memory

# Upload to S3
echo "Uploading backups to S3..."
aws s3 cp "$BACKUP_DIR/" "s3://$S3_BUCKET/$(date +%Y/%m/%d)/" --recursive

# Cleanup old backups
echo "Cleaning up old backups..."
find /backups -type f -mtime +$RETENTION_DAYS -delete
aws s3 ls "s3://$S3_BUCKET/" --recursive | while read -r line; do
    createDate=$(echo $line | awk '{print $1" "$2}')
    createDate=$(date -d "$createDate" +%s)
    olderThan=$(date -d "$RETENTION_DAYS days ago" +%s)
    if [[ $createDate -lt $olderThan ]]; then
        fileName=$(echo $line | awk '{$1=$2=$3=""; print $0}' | sed 's/^[ \t]*//')
        aws s3 rm "s3://$S3_BUCKET/$fileName"
    fi
done

echo "Backup completed successfully!"

# Send notification
curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"✅ FidgetFlo backup completed: $DATE\"}" \
    "$SLACK_WEBHOOK_URL"
```

---

## Security Configuration

### Secrets Management with AWS Secrets Manager

```bash
# Create secrets in AWS Secrets Manager
aws secretsmanager create-secret \
    --name "fidgetflo/api-keys" \
    --description "FidgetFlo API keys" \
    --secret-string '{
        "claude-api-key": "sk-ant-api03-...",
        "openai-api-key": "sk-...",
        "github-token": "ghp_..."
    }'

aws secretsmanager create-secret \
    --name "fidgetflo/database" \
    --description "Database connection details" \
    --secret-string '{
        "url": "postgresql://claude_flow:password@hostname:5432/claude_flow",
        "password": "secure-password"
    }'

aws secretsmanager create-secret \
    --name "fidgetflo/jwt" \
    --description "JWT and encryption secrets" \
    --secret-string '{
        "jwt-secret": "your-jwt-secret-256-bits",
        "encryption-key": "your-encryption-key-256-bits"
    }'
```

### WAF Configuration

```json
{
  "Name": "fidgetflo-waf",
  "Scope": "CLOUDFRONT",
  "DefaultAction": {
    "Allow": {}
  },
  "Rules": [
    {
      "Name": "AWSManagedRulesCommonRuleSet",
      "Priority": 1,
      "OverrideAction": {
        "None": {}
      },
      "Statement": {
        "ManagedRuleGroupStatement": {
          "VendorName": "AWS",
          "Name": "AWSManagedRulesCommonRuleSet"
        }
      },
      "VisibilityConfig": {
        "SampledRequestsEnabled": true,
        "CloudWatchMetricsEnabled": true,
        "MetricName": "CommonRuleSetMetric"
      }
    },
    {
      "Name": "RateLimitRule",
      "Priority": 2,
      "Action": {
        "Block": {}
      },
      "Statement": {
        "RateBasedStatement": {
          "Limit": 2000,
          "AggregateKeyType": "IP"
        }
      },
      "VisibilityConfig": {
        "SampledRequestsEnabled": true,
        "CloudWatchMetricsEnabled": true,
        "MetricName": "RateLimitMetric"
      }
    }
  ]
}
```

---

## Load Balancing

### AWS Application Load Balancer

```bash
# Create ALB
aws elbv2 create-load-balancer \
    --name fidgetflo-alb \
    --subnets subnet-12345 subnet-67890 \
    --security-groups sg-12345 \
    --scheme internet-facing \
    --type application \
    --ip-address-type ipv4

# Create target group
aws elbv2 create-target-group \
    --name fidgetflo-targets \
    --protocol HTTP \
    --port 3000 \
    --vpc-id vpc-12345 \
    --target-type ip \
    --health-check-enabled \
    --health-check-interval-seconds 30 \
    --health-check-path /health \
    --health-check-protocol HTTP \
    --health-check-timeout-seconds 5 \
    --healthy-threshold-count 2 \
    --unhealthy-threshold-count 2

# Create listener
aws elbv2 create-listener \
    --load-balancer-arn arn:aws:elasticloadbalancing:us-west-2:123456789:loadbalancer/app/fidgetflo-alb/1234567890abcdef \
    --protocol HTTPS \
    --port 443 \
    --certificates CertificateArn=arn:aws:acm:us-west-2:123456789:certificate/12345678-1234-1234-1234-123456789012 \
    --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-west-2:123456789:targetgroup/fidgetflo-targets/1234567890abcdef
```

---

## Cloud Deployment

### AWS Production Deployment

#### EKS Cluster Setup

```bash
#!/bin/bash
# Deploy FidgetFlo to AWS EKS

# Variables
CLUSTER_NAME="fidgetflo-production"
REGION="us-west-2"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Create EKS cluster
eksctl create cluster \
  --name $CLUSTER_NAME \
  --version 1.28 \
  --region $REGION \
  --nodegroup-name fidgetflo-workers \
  --node-type m5.large \
  --nodes 3 \
  --nodes-min 3 \
  --nodes-max 20 \
  --with-oidc \
  --ssh-access \
  --ssh-public-key ~/.ssh/id_rsa.pub \
  --managed

# Install AWS Load Balancer Controller
eksctl create iamserviceaccount \
  --cluster=$CLUSTER_NAME \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::$ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$CLUSTER_NAME \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

# Install EBS CSI driver
eksctl create addon \
  --name aws-ebs-csi-driver \
  --cluster $CLUSTER_NAME \
  --service-account-role-arn arn:aws:iam::$ACCOUNT_ID:role/AmazonEKS_EBS_CSI_DriverRole

echo "EKS cluster $CLUSTER_NAME created successfully!"
```

#### ECS Fargate Deployment

```json
{
  "family": "fidgetflo",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "2048",
  "memory": "4096",
  "executionRoleArn": "arn:aws:iam::ACCOUNT:role/ecsTaskExecutionRole",
  "taskRoleArn": "arn:aws:iam::ACCOUNT:role/claudeFlowTaskRole",
  "containerDefinitions": [
    {
      "name": "fidgetflo",
      "image": "ACCOUNT.dkr.ecr.us-west-2.amazonaws.com/fidgetflo:2.0.0",
      "portMappings": [
        {"containerPort": 3000, "protocol": "tcp"},
        {"containerPort": 8080, "protocol": "tcp"}
      ],
      "environment": [
        {"name": "NODE_ENV", "value": "production"},
        {"name": "FIDGETFLO_MAX_AGENTS", "value": "100"}
      ],
      "secrets": [
        {
          "name": "CLAUDE_API_KEY",
          "valueFrom": "arn:aws:secretsmanager:us-west-2:ACCOUNT:secret:fidgetflo/api-keys:claude-api-key::"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/fidgetflo",
          "awslogs-region": "us-west-2",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 60
      }
    }
  ]
}
```

```bash
# Deploy ECS service
aws ecs create-cluster --cluster-name fidgetflo-production

aws ecs register-task-definition --cli-input-json file://task-definition.json

aws ecs create-service \
  --cluster fidgetflo-production \
  --service-name fidgetflo \
  --task-definition fidgetflo:1 \
  --desired-count 3 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-12345,subnet-67890],securityGroups=[sg-12345],assignPublicIp=DISABLED}" \
  --load-balancers "targetGroupArn=arn:aws:elasticloadbalancing:us-west-2:ACCOUNT:targetgroup/fidgetflo/12345,containerName=fidgetflo,containerPort=3000" \
  --enable-logging
```

### Google Cloud Platform Production

#### GKE Deployment

```bash
#!/bin/bash
# Deploy to Google Kubernetes Engine

PROJECT_ID="your-project-id"
CLUSTER_NAME="fidgetflo-production"
REGION="us-central1"

# Create GKE cluster
gcloud container clusters create $CLUSTER_NAME \
  --project=$PROJECT_ID \
  --region=$REGION \
  --machine-type=e2-standard-4 \
  --num-nodes=3 \
  --min-nodes=3 \
  --max-nodes=20 \
  --enable-autoscaling \
  --enable-autorepair \
  --enable-autoupgrade \
  --enable-network-policy \
  --enable-ip-alias \
  --disk-size=50GB \
  --disk-type=pd-ssd \
  --release-channel=stable

# Get credentials
gcloud container clusters get-credentials $CLUSTER_NAME --region=$REGION --project=$PROJECT_ID

# Install ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml

# Deploy application
kubectl create namespace fidgetflo
kubectl apply -f k8s/ -n fidgetflo

echo "GKE deployment completed!"
```

#### Cloud Run Deployment

```yaml
# cloud-run.yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: fidgetflo
  annotations:
    run.googleapis.com/ingress: all
    run.googleapis.com/execution-environment: gen2
spec:
  template:
    metadata:
      annotations:
        autoscaling.knative.dev/minScale: "3"
        autoscaling.knative.dev/maxScale: "100"
        run.googleapis.com/cpu-throttling: "false"
        run.googleapis.com/memory: "4Gi"
        run.googleapis.com/cpu: "2"
    spec:
      containerConcurrency: 100
      containers:
      - image: gcr.io/PROJECT_ID/fidgetflo:2.0.0
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        - name: CLAUDE_API_KEY
          valueFrom:
            secretKeyRef:
              name: fidgetflo-secrets
              key: claude-api-key
        resources:
          limits:
            cpu: "2"
            memory: "4Gi"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 60
          periodSeconds: 30
        startupProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 10
          periodSeconds: 10
          failureThreshold: 30
```

```bash
# Deploy to Cloud Run
gcloud run services replace cloud-run.yaml \
  --region=us-central1 \
  --project=your-project-id
```

### Azure Deployment

```bash
# Deploy to Azure Container Instances
az container create \
  --resource-group fidgetflo-rg \
  --name fidgetflo \
  --image claudeflow/fidgetflo:latest \
  --dns-name-label fidgetflo \
  --ports 3000 \
  --environment-variables CLAUDE_API_KEY=$CLAUDE_API_KEY

# Deploy to Azure App Service
az webapp create \
  --resource-group fidgetflo-rg \
  --plan fidgetflo-plan \
  --name fidgetflo \
  --deployment-container-image-name claudeflow/fidgetflo:latest
```

### Heroku Deployment

```bash
# Create Heroku app
heroku create fidgetflo

# Set environment variables
heroku config:set CLAUDE_API_KEY=$CLAUDE_API_KEY
heroku config:set NODE_ENV=production

# Deploy
git push heroku main

# Scale dynos
heroku ps:scale web=3

# View logs
heroku logs --tail
```

---

## Production Setup

### SSL/TLS Configuration

```nginx
# nginx.conf
server {
    listen 80;
    server_name fidgetflo.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name fidgetflo.example.com;
    
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    
    location / {
        proxy_pass http://fidgetflo:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### Database Setup

#### PostgreSQL

```sql
-- Create database
CREATE DATABASE claude_flow;

-- Create user
CREATE USER claude_flow WITH ENCRYPTED PASSWORD 'secure_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE claude_flow TO claude_flow;

-- Create tables
\c claude_flow;

CREATE TABLE agents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL,
  config JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type VARCHAR(50) NOT NULL,
  description TEXT,
  status VARCHAR(50) NOT NULL,
  priority INTEGER DEFAULT 0,
  assigned_agent UUID REFERENCES agents(id),
  result JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_agents_type ON agents(type);
CREATE INDEX idx_agents_status ON agents(status);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_assigned ON tasks(assigned_agent);
```

### Backup Strategy

```bash
#!/bin/bash
# backup.sh

# Configuration
BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="claude_flow"

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup SQLite database
sqlite3 .swarm/memory.db ".backup '$BACKUP_DIR/memory_$DATE.db'"

# Backup PostgreSQL (if used)
pg_dump $DB_NAME > $BACKUP_DIR/postgres_$DATE.sql

# Backup configuration files
tar -czf $BACKUP_DIR/config_$DATE.tar.gz .fidgetflo/

# Backup logs
tar -czf $BACKUP_DIR/logs_$DATE.tar.gz logs/

# Upload to S3
aws s3 cp $BACKUP_DIR/ s3://fidgetflo-backups/ --recursive

# Clean old backups (keep last 30 days)
find $BACKUP_DIR -type f -mtime +30 -delete

echo "Backup completed: $DATE"
```

### Monitoring Script

```bash
#!/bin/bash
# monitor.sh

# Check service health
health_check() {
  response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health)
  if [ $response -eq 200 ]; then
    echo "✅ Service is healthy"
  else
    echo "❌ Service is unhealthy (HTTP $response)"
    # Send alert
    send_alert "FidgetFlo service is down"
  fi
}

# Check memory usage
check_memory() {
  memory=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')
  echo "📊 Memory usage: $memory"
  
  if [ ${memory%.*} -gt 90 ]; then
    send_alert "High memory usage: $memory"
  fi
}

# Check disk usage
check_disk() {
  disk=$(df -h / | awk 'NR==2{print $5}')
  echo "💾 Disk usage: $disk"
  
  if [ ${disk%?} -gt 90 ]; then
    send_alert "High disk usage: $disk"
  fi
}

# Send alert function
send_alert() {
  message=$1
  # Send to Slack
  curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"Alert: $message\"}" \
    $SLACK_WEBHOOK_URL
}

# Run checks
while true; do
  clear
  echo "FidgetFlo Monitoring - $(date)"
  echo "================================"
  health_check
  check_memory
  check_disk
  sleep 60
done
```

---

## Monitoring & Maintenance

### Health Checks

```javascript
// health-check.js
const healthCheck = {
  service: async () => {
    try {
      const response = await fetch('http://localhost:3000/health');
      return response.ok;
    } catch (error) {
      return false;
    }
  },
  
  database: async () => {
    try {
      const db = new Database('.swarm/memory.db');
      const result = db.prepare('SELECT 1').get();
      return result !== undefined;
    } catch (error) {
      return false;
    }
  },
  
  memory: () => {
    const used = process.memoryUsage();
    const limit = 2 * 1024 * 1024 * 1024; // 2GB
    return used.heapUsed < limit;
  }
};

// Run health checks
setInterval(async () => {
  const results = {
    service: await healthCheck.service(),
    database: await healthCheck.database(),
    memory: healthCheck.memory()
  };
  
  console.log('Health Check Results:', results);
  
  if (!Object.values(results).every(v => v)) {
    console.error('Health check failed!');
    // Send alert
  }
}, 60000); // Every minute
```

### Log Rotation

```bash
# /etc/logrotate.d/fidgetflo
/var/log/fidgetflo/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 node node
    sharedscripts
    postrotate
        /usr/bin/killall -SIGUSR1 node
    endscript
}
```

### Performance Tuning

```bash
# System limits configuration
# /etc/security/limits.conf
node soft nofile 65536
node hard nofile 65536
node soft nproc 32768
node hard nproc 32768

# Sysctl optimization
# /etc/sysctl.conf
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
```

---

## Troubleshooting

### Production Issues

#### Issue: Pod Crashes with OOMKilled

```bash
# Check memory usage
kubectl top pods -n fidgetflo

# Increase memory limits
kubectl patch deployment fidgetflo -n fidgetflo -p='{"spec":{"template":{"spec":{"containers":[{"name":"fidgetflo","resources":{"limits":{"memory":"8Gi"}}}]}}}}'

# Enable memory profiling
kubectl set env deployment/fidgetflo NODE_OPTIONS="--max-old-space-size=6144" -n fidgetflo
```

#### Issue: High Response Times

```bash
# Check pod resource usage
kubectl describe pod -l app=fidgetflo -n fidgetflo

# Scale up replicas
kubectl scale deployment fidgetflo --replicas=5 -n fidgetflo

# Check database connections
kubectl exec deployment/fidgetflo -n fidgetflo -- psql $DATABASE_URL -c "SELECT count(*) FROM pg_stat_activity;"

# Optimize database queries
kubectl exec deployment/fidgetflo -n fidgetflo -- npx fidgetflo@alpha db optimize
```

#### Issue: Database Connection Pool Exhaustion

```bash
# Check current connections
psql $DATABASE_URL -c "
SELECT 
    state,
    count(*) as connections 
FROM pg_stat_activity 
GROUP BY state;"

# Increase connection limits
kubectl patch configmap fidgetflo-config -n fidgetflo -p='{"data":{"config.json":"{\"database\":{\"pool\":{\"max\":50,\"min\":10}}}"}}'

# Restart deployment
kubectl rollout restart deployment/fidgetflo -n fidgetflo
```

#### Issue: Load Balancer Health Check Failures

```bash
# Check health endpoint
kubectl exec deployment/fidgetflo -n fidgetflo -- curl -f http://localhost:3000/health

# View detailed health status
kubectl exec deployment/fidgetflo -n fidgetflo -- npx fidgetflo@alpha diagnostics --health

# Check ingress configuration
kubectl describe ingress fidgetflo-ingress -n fidgetflo

# Test from outside cluster
curl -H "Host: api.fidgetflo.com" http://$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')/health
```

#### Issue: SSL Certificate Errors

```bash
# Check certificate status
kubectl get certificate fidgetflo-tls -n fidgetflo

# Describe certificate for details
kubectl describe certificate fidgetflo-tls -n fidgetflo

# Check cert-manager logs
kubectl logs deployment/cert-manager -n cert-manager

# Force certificate renewal
kubectl delete certificate fidgetflo-tls -n fidgetflo
kubectl apply -f k8s/cert-issuer.yaml
```

#### Issue: High CPU Usage

```bash
# Check CPU metrics
kubectl top pods -n fidgetflo

# Profile application
kubectl exec deployment/fidgetflo -n fidgetflo -- node --prof /app/dist/index.js &
# Let it run for a few minutes, then:
kubectl exec deployment/fidgetflo -n fidgetflo -- node --prof-process isolate-*.log > profile.txt

# Scale horizontally
kubectl patch hpa fidgetflo-hpa -n fidgetflo -p='{"spec":{"minReplicas":5,"maxReplicas":30}}'
```

### Debug Mode & Diagnostics

```bash
# Enable production debugging (use cautiously)
kubectl set env deployment/fidgetflo -n fidgetflo \
  FIDGETFLO_DEBUG=true \
  FIDGETFLO_LOG_LEVEL=debug

# Get comprehensive diagnostics
kubectl exec deployment/fidgetflo -n fidgetflo -- npx fidgetflo@alpha diagnostics --full > diagnostic-report.txt

# Monitor real-time logs
kubectl logs -f deployment/fidgetflo -n fidgetflo --tail=100

# Export cluster information
kubectl cluster-info dump > cluster-dump.txt

# Check resource quotas
kubectl describe quota -n fidgetflo

# View events
kubectl get events -n fidgetflo --sort-by='.metadata.creationTimestamp'
```

### Emergency Procedures

#### Emergency Shutdown

```bash
#!/bin/bash
# emergency-shutdown.sh

echo "🚨 EMERGENCY: Shutting down FidgetFlo..."

# Scale down to zero
kubectl scale deployment fidgetflo --replicas=0 -n fidgetflo

# Stop autoscaling
kubectl patch hpa fidgetflo-hpa -n fidgetflo -p='{"spec":{"minReplicas":0,"maxReplicas":0}}'

# Cordon nodes (if necessary)
# kubectl cordon <node-name>

# Send alert
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"🚨 EMERGENCY: FidgetFlo has been shut down!"}' \
  "$SLACK_WEBHOOK_URL"

echo "✅ Emergency shutdown complete"
```

#### Circuit Breaker Response

```bash
# Implement circuit breaker for external APIs
kubectl patch configmap fidgetflo-config -n fidgetflo -p='{
  "data": {
    "config.json": "{\"circuitBreaker\":{\"enabled\":true,\"threshold\":10,\"timeout\":60000}}"
  }
}'

# Restart to apply changes
kubectl rollout restart deployment/fidgetflo -n fidgetflo
```

### Performance Debugging

```bash
# Memory leak detection
kubectl exec deployment/fidgetflo -n fidgetflo -- node --trace-gc --expose-gc /app/dist/index.js

# CPU profiling in production
kubectl exec deployment/fidgetflo -n fidgetflo -- node --prof-process /tmp/isolate-*.log > cpu-profile.txt

# Network debugging
kubectl exec deployment/fidgetflo -n fidgetflo -- netstat -tupln
kubectl exec deployment/fidgetflo -n fidgetflo -- ss -tulpn

# Database query analysis
kubectl exec deployment/fidgetflo -n fidgetflo -- psql $DATABASE_URL -c "
SELECT query, calls, total_time, mean_time 
FROM pg_stat_statements 
ORDER BY total_time DESC 
LIMIT 10;"
```

---

## Support & Resources

### Production Support Runbook

```bash
#!/bin/bash
# support-runbook.sh - Quick diagnostic commands

echo "🔍 FidgetFlo Production Diagnostics"
echo "======================================"

echo "📊 Cluster Status:"
kubectl get nodes -o wide
kubectl get pods -n fidgetflo
kubectl top pods -n fidgetflo

echo "📈 Application Health:"
curl -s https://api.fidgetflo.com/health | jq '.'

echo "🐘 Database Status:"
psql $DATABASE_URL -c "SELECT version();" -t
psql $DATABASE_URL -c "SELECT count(*) as active_connections FROM pg_stat_activity WHERE state = 'active';" -t

echo "📦 Redis Status:"
redis-cli -u $REDIS_URL info memory | grep used_memory_human
redis-cli -u $REDIS_URL ping

echo "🔧 Recent Logs:"
kubectl logs deployment/fidgetflo -n fidgetflo --tail=50 --timestamps

echo "⚠️  Recent Alerts:"
curl -s http://alertmanager:9093/api/v1/alerts | jq '.data[] | select(.state=="firing") | .labels.alertname'

echo "📋 Resource Usage:"
kubectl describe nodes | grep -A 5 "Allocated resources"
```

### Monitoring Dashboards

- **Production Dashboard**: https://grafana.fidgetflo.com/d/fidgetflo-prod
- **Infrastructure Dashboard**: https://grafana.fidgetflo.com/d/infrastructure
- **Application Metrics**: https://grafana.fidgetflo.com/d/app-metrics
- **Database Performance**: https://grafana.fidgetflo.com/d/database
- **Alert Manager**: https://alertmanager.fidgetflo.com

### Emergency Contacts

```yaml
# On-Call Escalation
Level 1: DevOps Team
  - Slack: #devops-alerts
  - PagerDuty: fidgetflo-devops
  
Level 2: Engineering Team
  - Slack: #engineering-oncall
  - Email: engineering-oncall@fidgetflo.com
  
Level 3: Leadership
  - Slack: #leadership-alerts
  - Phone: Emergency hotline
```

### Documentation Links

- **Architecture Guide**: [ARCHITECTURE.md](./ARCHITECTURE.md)
- **API Documentation**: [API_DOCUMENTATION.md](./API_DOCUMENTATION.md)  
- **Development Workflow**: [DEVELOPMENT_WORKFLOW.md](./DEVELOPMENT_WORKFLOW.md)
- **Main Documentation**: [INDEX.md](./INDEX.md)
- **Repository**: https://github.com/ruvnet/claude-flow
- **Issues**: https://github.com/ruvnet/claude-flow/issues

### Quick Commands Reference

```bash
# Essential production commands
npx fidgetflo@alpha --version                    # Check version
npx fidgetflo@alpha diagnostics --full           # Full system check
npx fidgetflo@alpha swarm "test" --agents 3      # Quick functionality test
npx fidgetflo@alpha config validate              # Validate configuration

# Kubernetes shortcuts
alias kgp="kubectl get pods -n fidgetflo"
alias kgs="kubectl get svc -n fidgetflo"  
alias kgi="kubectl get ingress -n fidgetflo"
alias kl="kubectl logs -f deployment/fidgetflo -n fidgetflo"
alias kdp="kubectl describe pod -l app=fidgetflo -n fidgetflo"

# Emergency commands
kubectl scale deployment fidgetflo --replicas=0 -n fidgetflo  # Emergency stop
kubectl rollout undo deployment/fidgetflo -n fidgetflo        # Rollback
kubectl get events --sort-by='.metadata.creationTimestamp' -n fidgetflo  # Recent events
```

---

<div align="center">

## 🚀 **FidgetFlo Production Deployment Guide v2.0.0**

**Ready for Enterprise Scale • Production Tested • Fully Documented**

[📚 Documentation Home](./INDEX.md) | [🏗️ Architecture](./ARCHITECTURE.md) | [📖 API Reference](./API_DOCUMENTATION.md) | [⚡ Development](./DEVELOPMENT_WORKFLOW.md)

[🐙 GitHub Repository](https://github.com/ruvnet/claude-flow) | [🐛 Report Issues](https://github.com/ruvnet/claude-flow/issues) | [💬 Community Support](https://discord.gg/fidgetflo)

</div>