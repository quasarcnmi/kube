#!/bin/bash
echo ======================
echo Customizing for MODA
echo ======================
if  [ $USER = 'root' ] 
then
echo Cannot be root
exit 
fi
# Set the IP addresses of the admin, masters, and workers nodes
export admin=(admin1 10.0.0.6 eth0)
export master1=(master1 10.0.0.2 eth0)
export master2=(master2 10.0.0.3 eth0)
export master3=(master3 10.0.0.4 eth0)
export worker1=(worker1 10.0.0.5 eth0)
export vip=10.0.0.10
# User of remote machines
export user=quasar

# Array of all master nodes
export allmasters=($master1 $master2 $master3)

# Array of master nodes
export masters=($master2 $master3)

# Array of worker nodes
export workers=($worker1)
# Array of all
export all=($master1 $master2 $master3 $worker1)

# Array of all minus master1
export allnomaster1=($master2 $master3 $worker1)

#Loadbalancer IP range
export lbrange=10.0.1.2-10.0.1.128

#ssh certificate name variable
export certName=id_rsa

INSTALLDIR="$HOME/kube-installer"

cd $INSTALLDIR/admin1

token=`cat token`
cat rke2.yaml | sed 's/127.0.0.1/'$vip'/g' > $HOME/.kube/config
export KUBECONFIG=${HOME}/.kube/config
sudo cp ~/.kube/config /etc/rancher/rke2/rke2.yaml

kubectl get nodes


for node in ${masters[@]} ; do
declare -n n=$node
serverName=${n[0]}

cp ~/.kube/config $INSTALLDIR/$serverName/rke2.yanl
done

#Create rke2 config
for node in "${masters[@]}"; do
  declare -n n=$node
serverName=${n[0]}
  cat <<EOF > $INSTALLDIR/$serverName/config.yaml
  token: $token
  server: https://$master1:9345
  tls-san:
    - $vip" 
    - ${master1[0]}"
    - ${master2[0]}"
    - ${master3[0]}"
EOF
  cat <<EOF > $INSTALLDIR/$serverName/rke2-startup.sh
!#/bin/bash
systemctl stop firewalld
systemctl disable firewalld

mkdir -p /etc/rancher/rke2
mv config.yaml /etc/rancher/rke2/config.yaml
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service
EOF
scp $INSTALLDIR/$serverName/* $user@$serverName:
done


# Create the install scripts


#Create rke2 config
for node in "${workers[@]}"; do
  declare -n n=$node
    serverName=${n[0]}
 
  cat <<EOF > $INSTALLDIR/$serverName/config.yaml
  token: $token
  server: https://$vip:9345
  node-label:
     - worker=true
     - longhorn=true
EOF


  cat <<EOF > $INSTALLDIR/$serverName/rke2-startup.sh
!#/bin/bash
systemctl stop firewalld
systemctl disable firewalld
 
mkdir -p /etc/rancher/rke2
mv config.yaml /etc/rancher/rke2/config.yaml
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -
systemctl enable rke2-agent.service
systemctl start rke2-agent.service
EOF
scp $INSTALLDIR/$serverName/* $user@$serverName:
done


