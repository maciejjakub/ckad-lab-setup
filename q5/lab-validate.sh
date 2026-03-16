#!/bin/bash
SELECTOR=$(kubectl get svc frontend-svc -o jsonpath='{.spec.selector.app}')
EP_COUNT=$(kubectl get endpoints frontend-svc -o jsonpath='{range .subsets[*].addresses[*]}{.ip}{"\n"}{end}' | wc -l)
if [[ "$SELECTOR" == "frontend" ]] && [ "$EP_COUNT" -gt 1 ]; then
  echo "✅ Canary setup confirmed (multiple endpoints)."
else
  echo "❌ Canary setup failed."
fi