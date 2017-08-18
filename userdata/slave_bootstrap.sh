#!/bin/sh
sudo systemctl stop firewalld
sudo systemctl disable firewalld

for SERVICES in kube-proxy kubelet docker flanneld; do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES 
done
