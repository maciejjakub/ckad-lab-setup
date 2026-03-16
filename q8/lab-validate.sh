#!/bin/bash
USER=$(kubectl get deploy secure-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.runAsUser}')
CAP=$(kubectl get deploy secure-app -o jsonpath='{.spec.template.spec.containers[0].securityContext.capabilities.add[0]}')
if [[ "$USER" == "1000" ]] && [[ "$CAP" == "NET_ADMIN" ]]; then
  echo "✅ Security context applied."
else
  echo "❌ Security context incorrect."
fi