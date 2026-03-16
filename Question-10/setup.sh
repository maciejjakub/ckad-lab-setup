#!/bin/bash
# Question 10 – Add Readiness Probe to Deployment
# Sets up: Deployment 'api-deploy' in namespace 'default' with container on port 8080, no probe

echo "[setup] Creating Deployment 'api-deploy' with container on port 8080 (no readiness probe)..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deploy
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api-deploy
  template:
    metadata:
      labels:
        app: api-deploy
    spec:
      containers:
        - name: api
          image: nginx:latest
          ports:
            - containerPort: 8080
EOF

echo "[setup] Waiting for Deployment to be ready..."
kubectl rollout status deployment/api-deploy -n default --timeout=60s

echo ""
echo "[setup] Done! Your task:"
echo "  Add a readiness probe to Deployment 'api-deploy' with:"
echo "  - HTTP GET on path /ready, port 8080"
echo "  - initialDelaySeconds: 5"
echo "  - periodSeconds: 10"
