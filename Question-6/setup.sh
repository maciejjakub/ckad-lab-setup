#!/bin/bash
# Question 6 – Create Canary Deployment with Manual Traffic Split
# Sets up: Deployment 'web-app' with 5 replicas and Service 'web-service'

echo "[setup] Creating Deployment 'web-app' with 5 replicas..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: default
  labels:
    app: webapp
    version: v1
spec:
  replicas: 5
  selector:
    matchLabels:
      app: webapp
      version: v1
  template:
    metadata:
      labels:
        app: webapp
        version: v1
    spec:
      containers:
        - name: web
          image: nginx:1.20
EOF

echo "[setup] Creating Service 'web-service' selecting app=webapp..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: default
spec:
  selector:
    app: webapp
  ports:
    - port: 80
      targetPort: 80
EOF

echo "[setup] Waiting for Deployment to be ready..."
kubectl rollout status deployment/web-app -n default --timeout=60s

echo ""
echo "[setup] Done! Your task:"
echo "  1. Scale Deployment 'web-app' to 8 replicas"
echo "  2. Create Deployment 'web-app-canary' with 2 replicas, labels app=webapp version=v2"
echo "  3. Both Deployments should be selected by 'web-service' (which selects app=webapp)"
