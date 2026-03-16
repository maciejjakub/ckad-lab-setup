#!/bin/bash
# Question 16 – Add Resource Requests and Limits to Pod
# Sets up: namespace 'prod' with a ResourceQuota

echo "[setup] Creating namespace 'prod'..."
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -

echo "[setup] Creating ResourceQuota in namespace 'prod'..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: ResourceQuota
metadata:
  name: prod-quota
  namespace: prod
spec:
  hard:
    limits.cpu: "2"
    limits.memory: "4Gi"
    requests.cpu: "1"
    requests.memory: "2Gi"
    pods: "10"
EOF

echo ""
echo "[setup] Done! Your task:"
echo "  1. Check the ResourceQuota: kubectl get quota -n prod && kubectl describe quota prod-quota -n prod"
echo "  2. Create a Pod named 'resource-pod' in namespace 'prod' with:"
echo "     - Image: nginx:latest"
echo "     - CPU limit: half of quota limits.cpu (quota is 2, so use 1 or 1000m)"
echo "     - Memory limit: half of quota limits.memory (quota is 4Gi, so use 2Gi)"
echo "     - CPU request: at least 100m"
echo "     - Memory request: at least 128Mi"
