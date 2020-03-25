#!/usr/bin/env bash

curl http://mirrors.aliyun.com/repo/Centos-7.repo -o /etc/yum.repos.d/CentOS-Base.repo
yum install -y epel-release
yum install -y git python-pip

mkdir -p ~/.pip
cat << EOF > ~/.pip/pip.conf
[global]
trusted-host =  mirrors.aliyun.com
index-url = http://mirrors.aliyun.com/pypi/simple/
EOF

if [[ ! -d /tmp/kubernetes-ansible ]]; then
    git clone https://github.com/yingjuncao/kubernetes-ansible /tmp/kubernetes-ansible
    cp -r /tmp/kubernetes-ansible/etc/kubernetes-ansible/ /etc/
fi

pip install ansible==2.5.0 /tmp/kubernetes-ansible/

kubernetes-ansible bootstrap-servers && \
kubernetes-ansible deploy && \
kubernetes-ansible post-deploy

. /root/admin-k8src.sh

kubectl get node
