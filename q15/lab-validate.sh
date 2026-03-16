#!/bin/bash
LIMIT=$(kubectl get job batch-job -o jsonpath='{.spec.backoffLimit}')
if [[ "$LIMIT" == "5" ]]; then
  echo "✅ Job backoffLimit is 5."
else
  echo "❌ Incorrect backoffLimit."
fi