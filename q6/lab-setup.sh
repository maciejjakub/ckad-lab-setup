#!/bin/bash
kubectl run db --image=redis --labels=app=db
kubectl run backend --image=nginx --labels=app=backend
kubectl run frontend --image=nginx --labels=app=frontend