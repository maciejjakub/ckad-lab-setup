#!/bin/bash
kubectl create namespace marketing
kubectl create deployment web-app --image=nginx -n marketing