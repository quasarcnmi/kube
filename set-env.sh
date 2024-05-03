#!/bin/bash

echo ======================
echo Customizing for MODA
echo ======================

sudo dnf install jq mc curl wget 


# Version of Kube-VIP to deploy
export KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases | jq -r ".[0].name")
# Set the IP addresses of the admin, masters, and workers nodes
admin=(10.0.0.6 eth0)
master1=(10.0.0.2 eth0)
master2=(10.0.0.3 eth0)
master3=(10.0.0.4 eth0)
worker1=(10.0.0.5 eth0)
vip=10.0.0.10
# User of remote machines
export user=quasar

# Array of all master nodes
allmasters=($master1 $master2 $master3)

# Array of master nodes
masters=($master2 $master3)

# Array of worker nodes
workers=($worker1)
# Array of all
all=($master1 $master2 $master3 $worker1)

# Array of all minus master1
allnomaster1=($master2 $master3 $worker1)

#Loadbalancer IP range
lbrange=10.0.1.2-10.0.1.128

#ssh certificate name variable
certName=id_rsa


## For testing purposes - in case time is wrong due to VM snapshots
sudo timedatectl set-ntp off
sudo timedatectl set-ntp on

# Install Kubectl on the Admin server if not already present
if ! command -v kubectl version &> /dev/null
then
    echo "Kubectl not found, installing"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
else
    echo "Kubectl already installed"
fi

#add ssh keys for all nodes
for node in "${all[@]}"; do
  ssh-copy-id $user@${$node[0]
done


bash

