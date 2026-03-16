#!/bin/bash
kubectl create namespace quota-demo
kubectl create resourcequota mem-quota --hard=limits.memory=1Gi -n quota-demo