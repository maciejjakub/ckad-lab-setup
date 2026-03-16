#!/bin/bash
cat <<EOF > /tmp/broken.yaml
apiVersion: apps/v2
kind: Deployment
metadata:
  name: fixed-deploy
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: fixed
    spec:
      containers:
      - name: nginx
        image: nginx
EOF