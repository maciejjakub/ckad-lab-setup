#!/bin/bash
# Question 8 – Fix Broken Deployment YAML
# Sets up: /root/broken-deploy.yaml with multiple issues

echo "[setup] Creating /root/broken-deploy.yaml with intentional errors..."

cat > /root/broken-deploy.yaml <<'EOF'
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: broken-app
  namespace: default
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: web
          image: nginx
EOF

echo "[setup] File created at /root/broken-deploy.yaml"
echo ""
echo "[setup] Done! Your task:"
echo "  Fix /root/broken-deploy.yaml which has these issues:"
echo "  1. Uses deprecated apiVersion: extensions/v1beta1 (should be apps/v1)"
echo "  2. Missing required 'selector' field"
echo "  3. Apply the fixed manifest and ensure Deployment 'broken-app' is running"
