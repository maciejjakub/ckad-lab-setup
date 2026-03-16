#!/bin/bash
# Question 9 – Perform Rolling Update and Rollback
# Sets up: Deployment 'app-v1' in namespace 'default' with image nginx:1.20

echo "[setup] Creating Deployment 'app-v1' with image nginx:1.20..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-v1
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: app-v1
  template:
    metadata:
      labels:
        app: app-v1
    spec:
      containers:
        - name: web
          image: nginx:1.20
EOF

echo "[setup] Waiting for Deployment to be ready..."
kubectl rollout status deployment/app-v1 -n default --timeout=90s

echo ""
echo "[setup] Done! Your task:"
echo "  1. Update Deployment 'app-v1' to use image nginx:1.25"
echo "  2. Verify the rolling update completes successfully"
echo "  3. Rollback to the previous revision (nginx:1.20)"
echo "  4. Verify the rollback completed and image is nginx:1.20"
