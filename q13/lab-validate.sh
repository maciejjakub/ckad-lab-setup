#!/bin/bash
LIMIT=$(kubectl get pod mem-pod -n quota-demo -o jsonpath='{.spec.containers[0].resources.limits.memory}')
if [[ "$LIMIT" == "512Mi" ]]; then
  echo "✅ Resource limits set correctly."
else
  echo "❌ Resource limit mismatch. Found: $LIMIT"
fi