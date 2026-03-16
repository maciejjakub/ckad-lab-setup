#!/bin/bash
# Question 4 – Fix Broken Pod with Correct ServiceAccount
# Sets up: namespace 'monitoring' with multiple SAs, Roles, RoleBindings, and a misconfigured Pod

echo "[setup] Creating namespace 'monitoring'..."
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "[setup] Creating ServiceAccounts..."
kubectl create serviceaccount monitor-sa -n monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl create serviceaccount wrong-sa    -n monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl create serviceaccount admin-sa    -n monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "[setup] Creating Roles..."
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: metrics-reader
  namespace: monitoring
rules:
  - apiGroups: [""]
    resources: ["pods", "services", "endpoints"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: full-access
  namespace: monitoring
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: view-only
  namespace: monitoring
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get"]
EOF

echo "[setup] Creating RoleBindings..."
kubectl create rolebinding monitor-binding \
  --role=metrics-reader \
  --serviceaccount=monitoring:monitor-sa \
  -n monitoring --dry-run=client -o yaml | kubectl apply -f -

kubectl create rolebinding admin-binding \
  --role=full-access \
  --serviceaccount=monitoring:admin-sa \
  -n monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "[setup] Creating Pod 'metrics-pod' using wrong-sa..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: metrics-pod
  namespace: monitoring
spec:
  serviceAccountName: wrong-sa
  containers:
    - name: metrics
      image: nginx:latest
EOF

echo "[setup] Waiting for Pod to start..."
kubectl wait --for=condition=Ready pod/metrics-pod -n monitoring --timeout=60s 2>/dev/null || true

echo ""
echo "[setup] Done! Your task:"
echo "  1. Investigate which ServiceAccount has the correct permissions for pod/service monitoring"
echo "  2. Update Pod 'metrics-pod' to use the correct ServiceAccount"
echo ""
echo "  Hint: Check RoleBindings to see which SA is bound to which Role."
