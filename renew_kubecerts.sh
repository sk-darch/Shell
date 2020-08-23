#!/bin/bash

echo -e "#########################################\nMoving old certificates to different directory\n#########################################"
cd /etc/kubernetes/pki/ || exit
mv {apiserver.crt,apiserver-etcd-client.key,apiserver-kubelet-client.crt,front-proxy-ca.crt,front-proxy-client.crt,front-proxy-client.key,front-proxy-ca.key,apiserver-kubelet-client.key,apiserver.key,apiserver-etcd-client.crt} ~/
cd  /etc/kubernetes/pki/etcd/ || exit
mv {ca.crt,ca.key,healthcheck-client.crt,healthcheck-client.key,peer.crt,peer.key,server.crt,server.key} ~/

echo -e "***********************************\nInitiating renew certificates\n**************************************"
kubeadm init phase certs all --apiserver-advertise-address $1
if [ $? -eq  0 ]
then
    echo "Certs renewed successfully"
else
    exit 1
fi

echo -e "#########################################\nMoving old config to different directory\n#########################################"
cd /etc/kubernetes/ || exit
mv {admin.conf,controller-manager.conf,kubelet.conf,scheduler.conf} ~/

echo -e "**************************************\nInitiating renewing kube configs\n**************************************"
kubeadm init phase kubeconfig all
if [ $? -ne  0 ]
then
    exit 1
else
    echo "configs renewed successfully"
    sleep 10
    echo "Rebooting the server"
    reboot
fi