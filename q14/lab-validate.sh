#!/bin/bash
kubectl get deploy fixed-deploy &> /dev/null
if [ $? -eq 0 ]; then
  echo "✅ Deployment fixed and running."
else
  echo "❌ Deployment not found."
fi