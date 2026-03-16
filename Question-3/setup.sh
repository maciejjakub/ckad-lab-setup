#!/bin/bash
# Question 3 – Create ServiceAccount, Role, and RoleBinding from Logs Error
# Sets up: namespace 'audit' with Pod 'log-collector' failing due to missing permissions

echo "[setup] Creating namespace 'audit'..."
kubectl create namespace audit --dry-run=client -o yaml | kubectl apply -f -

echo "[setup] Creating Pod 'log-collector' in namespace 'audit'..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: log-collector
  namespace: audit
spec:
  serviceAccountName: default
  containers:
    - name: log-collector
      image: bitnami/kubectl:latest
      command: ["/bin/sh", "-c"]
      args:
        - |
          while true; do
            echo 'User "system:serviceaccount:audit:default" cannot list pods in the namespace "audit"'
            sleep 10
          done
EOF

echo "[setup] Waiting for Pod to start..."
kubectl wait --for=condition=Ready pod/log-collector -n audit --timeout=60s 2>/dev/null || true

echo ""
echo "[setup] Done! Your task:"
echo "  1. Create ServiceAccount 'log-sa' in namespace 'audit'"
echo "  2. Create Role 'log-role' granting get/list/watch on pods"
echo "  3. Create RoleBinding 'log-rb' binding log-role to log-sa"
echo "  4. Update Pod 'log-collector' to use ServiceAccount 'log-sa'"
