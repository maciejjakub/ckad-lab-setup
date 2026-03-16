#!/bin/bash
# Question 7 – Fix NetworkPolicy by Updating Pod Labels
# Sets up: namespace 'network-demo' with 3 Pods with wrong labels and 3 NetworkPolicies

echo "[setup] Creating namespace 'network-demo'..."
kubectl create namespace network-demo --dry-run=client -o yaml | kubectl apply -f -

echo "[setup] Creating NetworkPolicies..."
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: network-demo
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: network-demo
spec:
  podSelector:
    matchLabels:
      role: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: frontend
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-db
  namespace: network-demo
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: backend
EOF

echo "[setup] Creating Pods with incorrect labels..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: network-demo
  labels:
    role: wrong-frontend
spec:
  containers:
    - name: app
      image: nginx:latest
---
apiVersion: v1
kind: Pod
metadata:
  name: backend
  namespace: network-demo
  labels:
    role: wrong-backend
spec:
  containers:
    - name: app
      image: nginx:latest
---
apiVersion: v1
kind: Pod
metadata:
  name: database
  namespace: network-demo
  labels:
    role: wrong-db
spec:
  containers:
    - name: app
      image: nginx:latest
EOF

echo "[setup] Waiting for Pods to start..."
kubectl wait --for=condition=Ready pod/frontend pod/backend pod/database -n network-demo --timeout=60s 2>/dev/null || true

echo ""
echo "[setup] Done! Your task:"
echo "  Update Pod labels (do NOT modify NetworkPolicies) to enable: frontend -> backend -> database"
echo "  Hint: Use 'kubectl label pod <name> -n network-demo role=<correct-value> --overwrite'"
