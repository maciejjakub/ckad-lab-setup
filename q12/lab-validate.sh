#!/bin/bash
IMG=$(kubectl get deploy worker-app -o jsonpath='{.spec.template.spec.containers[0].image}')
if [[ "$IMG" == "nginx:1.19" ]]; then
  echo "✅ Image updated to 1.19."
else
  echo "❌ Image is still $IMG."
fi