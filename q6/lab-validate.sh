#!/bin/bash
SPEC=$(kubectl get netpol allow-db -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}')
if [[ "$SPEC" == "backend" ]]; then
  echo "✅ NetworkPolicy allows traffic from backend."
else
  echo "❌ NetworkPolicy selector is incorrect."
fi