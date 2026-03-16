#!/bin/bash
# Question 14 – Create Ingress Resource
# Sets up: Deployment 'web-deploy' and Service 'web-svc' on port 8080

echo "[setup] Creating Deployment 'web-deploy' with label app=web..."
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: web
          image: nginx:latest
          ports:
            - containerPort: 8080
EOF

echo "[setup] Creating Service 'web-svc' on port 8080..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: default
spec:
  selector:
    app: web
  ports:
    - port: 8080
      targetPort: 8080
EOF

echo "[setup] Waiting for Deployment to be ready..."
kubectl rollout status deployment/web-deploy -n default --timeout=60s

echo ""
echo "[setup] Done! Your task:"
echo "  Create an Ingress named 'web-ingress' in namespace 'default' that:"
echo "  - apiVersion: networking.k8s.io/v1"
echo "  - Host: web.example.com"
echo "  - Path: / with pathType: Prefix"
echo "  - Backend: Service 'web-svc' on port 8080"
