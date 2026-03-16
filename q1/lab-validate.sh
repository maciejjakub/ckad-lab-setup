#!/bin/bash
# Check if secret exists
kubectl get secret api-secret -n internal &> /dev/null
if [ $? -eq 0 ]; then
  echo "✅ Secret api-secret exists."
else
  echo "❌ Secret api-secret is missing."
fi

# Check if deployment is using the secret
ENV_CHECK=$(kubectl get deploy api-server -n internal -o jsonpath='{.spec.template.spec.containers[0].env[*].valueFrom.secretKeyRef.name}')
if [[ "$ENV_CHECK" == *"api-secret"* ]]; then
  echo "✅ Deployment api-server is correctly using the secret."
else
  echo "❌ Deployment is not configured to use the secret."
fi