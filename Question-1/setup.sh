#!/bin/bash
# Question 1 – Create Secret from Hardcoded Variables
# Sets up: Deployment 'api-server' in namespace 'default' with hardcoded env vars

echo "[setup] Creating Deployment 'api-server' with hardcoded environment variables..."

kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api-server
  template:
    metadata:
      labels:
        app: api-server
    spec:
      containers:
        - name: api
          image: nginx:latest
          env:
            - name: DB_USER
              value: "admin"
            - name: DB_PASS
              value: "Secret123!"
EOF

echo "[setup] Waiting for Deployment to be ready..."
kubectl rollout status deployment/api-server -n default --timeout=60s

echo ""
echo "[setup] Done! Your task:"
echo "  1. Create a Secret named 'db-credentials' in namespace 'default'"
echo "     containing DB_USER=admin and DB_PASS=Secret123!"
echo "  2. Update Deployment 'api-server' to use the Secret via valueFrom.secretKeyRef"
