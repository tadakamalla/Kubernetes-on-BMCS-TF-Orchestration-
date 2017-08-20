#!/bin/sh
sleep 30 
kubectl create -f /tmp/mynode.yaml
kubectl create -f /tmp/mynode-service.yaml
kubectl create -f /tmp/redis-master.yaml
kubectl create -f /tmp/redis-sentinel-service.yaml
kubectl create -f /tmp/redis-controller.yaml

