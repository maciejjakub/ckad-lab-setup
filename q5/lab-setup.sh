#!/bin/bash
kubectl create deployment frontend-v1 --image=nginx:1.18 --port=80
kubectl expose deployment frontend-v1 --name=frontend-svc --port=80 --selector=app=frontend