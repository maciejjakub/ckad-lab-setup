#!/bin/bash
# Question 15 – Fix Ingress PathType
# Sets up: /root/fix-ingress.yaml with invalid pathType and a Service 'api-svc'

echo "[setup] Creating Service 'api-svc' in namespace 'default'..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: api-svc
  namespace: default
spec:
  selector:
    app: api
  ports:
    - port: 8080
      targetPort: 8080
EOF

echo "[setup] Creating /root/fix-ingress.yaml with invalid pathType..."
cat > /root/fix-ingress.yaml <<'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  namespace: default
spec:
  rules:
    - http:
        paths:
          - path: /api
            pathType: InvalidType
            backend:
              service:
                name: api-svc
                port:
                  number: 8080
EOF

echo "[setup] File created at /root/fix-ingress.yaml"
echo ""
echo "[setup] Done! Your task:"
echo "  1. Try: kubectl apply -f /root/fix-ingress.yaml  (it will fail)"
echo "  2. Fix the invalid pathType value in /root/fix-ingress.yaml"
echo "     Valid values: Prefix, Exact, ImplementationSpecific"
echo "  3. Apply the fixed manifest successfully"
