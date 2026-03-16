#!/bin/bash
# Question 11 – Configure Pod and Container Security Context
# Sets up: Deployment 'secure-app' in namespace 'default' without any security context

echo "[setup] Creating Deployment 'secure-app' without security context..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secure-app
  template:
    metadata:
      labels:
        app: secure-app
    spec:
      containers:
        - name: app
          image: nginx:latest
EOF

echo "[setup] Waiting for Deployment to be ready..."
kubectl rollout status deployment/secure-app -n default --timeout=60s

echo ""
echo "[setup] Done! Your task:"
echo "  1. Set Pod-level securityContext: runAsUser: 1000"
echo "  2. Add container-level capability NET_ADMIN to the container named 'app'"
echo "  Note: runAsUser goes on spec.securityContext, capabilities go on the container's securityContext"
