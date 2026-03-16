#!/bin/bash
HOST=$(kubectl get ingress api-ingress -o jsonpath='{.spec.rules[0].host}')
PATH=$(kubectl get ingress api-ingress -o jsonpath='{.spec.rules[0].http.paths[0].path}')
if [[ "$HOST" == "app.example.com" ]] && [[ "$PATH" == "/api" ]]; then
  echo "✅ Ingress configured correctly."
else
  echo "❌ Ingress configuration error."
fi