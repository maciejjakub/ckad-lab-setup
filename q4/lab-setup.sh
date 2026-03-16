#!/bin/bash
kubectl create namespace auth
kubectl run auth-service --image=nginx -n auth