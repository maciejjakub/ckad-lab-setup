#!/bin/bash
SA=$(kubectl get deploy web-app -n marketing -o jsonpath='{.spec.template.spec.containers[0].serviceAccountName}')
if [[ "$SA" == "app-sa" ]]; then
  echo "✅ Deployment is using app-sa."
else
  echo "❌ Deployment is not using the correct ServiceAccount."
fi