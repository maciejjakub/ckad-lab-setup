#!/bin/bash
COUNT=$(kubectl get pod logger-pod -o jsonpath='{len(.spec.containers)}')
VOL_TYPE=$(kubectl get pod logger-pod -o jsonpath='{.spec.volumes[0].emptyDir}')
if [ "$COUNT" -eq 2 ] && [ -n "$VOL_TYPE" ]; then
  echo "✅ Multi-container pod with emptyDir verified."
else
  echo "❌ Pod must have 2 containers and an emptyDir volume."
fi