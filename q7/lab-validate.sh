#!/bin/bash
LIVENESS=$(kubectl get deploy nginx-probe -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.httpGet.port}')
READINESS=$(kubectl get deploy nginx-probe -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.tcpSocket.port}')
if [[ "$LIVENESS" == "80" ]] && [[ "$READINESS" == "80" ]]; then
  echo "✅ Probes configured."
else
  echo "❌ Probes are missing or incorrect."
fi