#!/bin/bash
# Question 13 – Create NodePort Service
# Sets up: Deployment 'api-server' with Pods labeled app=api on port 9090

echo "[setup] Creating Deployment 'api-server' with label app=api and containerPort 9090..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
        - name: api
          image: nginx:latest
          ports:
            - containerPort: 9090
EOF

echo "[setup] Waiting for Deployment to be ready..."
kubectl rollout status deployment/api-server -n default --timeout=60s

echo ""
echo "[setup] Done! Your task:"
echo "  Create a NodePort Service named 'api-nodeport' that:"
echo "  - Type: NodePort"
echo "  - Selects Pods with label app=api"
echo "  - port: 80 -> targetPort: 9090"
