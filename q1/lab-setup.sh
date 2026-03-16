#!/bin/bash
kubectl create namespace internal
kubectl create deployment api-server --image=nginx -n internal