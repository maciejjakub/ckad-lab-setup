#!/bin/bash
# Question 12 – Fix Service Selector
# Sets up: Deployment 'web-app' with correct labels and Service 'web-svc' with wrong selector

echo "[setup] Creating Deployment 'web-app' with labels app=webapp, tier=frontend..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
      tier: frontend
  template:
    metadata:
      labels:
        app: webapp
        tier: frontend
    spec:
      containers:
        - name: web
          image: nginx:latest
          ports:
            - containerPort: 80
EOF

echo "[setup] Creating Service 'web-svc' with INCORRECT selector app=wrongapp..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: default
spec:
  selector:
    app: wrongapp
  ports:
    - port: 80
      targetPort: 80
EOF

echo "[setup] Waiting for Deployment to be ready..."
kubectl rollout status deployment/web-app -n default --timeout=60s

echo ""
echo "[setup] Done! Your task:"
echo "  Update Service 'web-svc' selector from app=wrongapp to app=webapp"
echo "  so it correctly targets Pods from Deployment 'web-app'"
