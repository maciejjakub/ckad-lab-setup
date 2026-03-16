#!/bin/bash
PHASE=$(kubectl get pvc task-pvc -o jsonpath='{.status.phase}')
MOUNT=$(kubectl get pod storage-pod -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}')
if [[ "$PHASE" == "Bound" ]] && [[ "$MOUNT" == "/data" ]]; then
  echo "✅ Storage bound and mounted."
else
  echo "❌ PVC not bound or not mounted to /data."
fi