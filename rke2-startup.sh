#!/bin/bash
systemctl stop firewalld
systemctl disable firewalld
# Install Kubectl on the Admin server if not already present
echo verifying kubectl is on
if ! command -v kubectl version &> /dev/null
then
    echo "Kubectl not found, installing"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
else
    echo "Kubectl already installed"
fi

mkdir -p /var/lib/rancher/rke2/server/manifests
mv kube-vip.yaml /var/lib/rancher/rke2/server/manifests/kube-vip.yaml
mkdir -p /etc/rancher/rke2
mv config.yaml /etc/rancher/rke2/config.yaml
echo 'export KUBECONFIG=/etc/rancher/rke2/rke2.yaml' >> ~/.bashrc ; echo 'export PATH=${PATH}:/var/lib/rancher/rke2/bin' >> ~/.bashrc ; echo 'alias k=kubectl' >> ~/.bashrc ; source ~/.bashrc ;
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service
cp /var/lib/rancher/rke2/server/token .
cp /etc/rancher/rke2/rke2.yaml .
chmod 600 token rke2.yaml

ssh-keygen 
ssh-copy-id quasar@admin1

scp token quasar@admin1:kube-installer/admin1/
scp rke2.yaml quasar@admin1:kube-installer/admin1/

export KUBECONFIG=rke2.yaml
kubectl get nodes 
kubectl apply -f https://kube-vip.io/manifests/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/kube-vip/kube-vip-cloud-provider/main/manifest/kube-vip-cloud-controller.yaml
kubectl get nodes 
