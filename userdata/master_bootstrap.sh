#!/bin/sh

sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo yum -y install ntp
sudo systemctl start ntpd
sudo systemctl enable ntpd


sudo yum -y install etcd kubernetes
openssl genrsa -out /tmp/serviceaccount.key 2048

sed -i 's|ETCD_LISTEN_CLIENT_URLS="http://localhost:2379"|ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"|' /etc/etcd/etcd.conf
sed -i 's/KUBE_API_ADDRESS="--insecure-bind-address=127.0.0.1"/KUBE_API_ADDRESS="--insecure-bind-address=0.0.0.0"/' /etc/kubernetes/apiserver  
sed -i 's/# KUBELET_PORT="--port=10250"/KUBELET_PORT="--port=10250"/'  /etc/kubernetes/apiserver
sed -i 's/# KUBE_API_PORT="--port=8080"/KUBE_API_PORT="--port=8080"/' /etc/kubernetes/apiserver
sed -i 's/KUBE_API_ARGS=""/KUBE_API_ARGS="--service_account_key_file=\/tmp\/serviceaccount.key"/' /etc/kubernetes/apiserver
sed -i 's/KUBE_CONTROLLER_MANAGER_ARGS=""/KUBE_CONTROLLER_MANAGER_ARGS="--service_account_private_key_file=\/tmp\/serviceaccount.key"/' /etc/kubernetes/controller-manager
for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler; do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES 
done
 etcdctl mk /atomic.io/network/config '{"Network":"172.17.0.0/16"}'
 
