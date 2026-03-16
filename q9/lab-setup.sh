#!/bin/bash
kubectl create deployment api-server --image=nginx
kubectl expose deployment api-server --name=api-service --port=8080 --target-port=80