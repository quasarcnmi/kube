#!/bin/bash




echo ======================
echo Customizing for MODA
echo ======================


if  [ $USER = 'root' ] 
then
echo Cannot be root
exit 
fi

echo Adding applications to Admin1

sudo dnf install jq mc curl wget 


# Version of Kube-VIP to deploy
export KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases | jq -r ".[0].name")
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


if [ ! -d $INSTALLDIR ]
then 
mkdir -p $INSTALLDIR
fi
# Clear the directory
rm -fr "$INSTALLDIR/*"

cd $INSTALLDIR 

if [  "$(pwd)" != "$INSTALLDIR" ] 
then
echo We are not in the $INSTALLDIR
exit 
fi

# Create install directories in $INSTALLDIR



## For testing purposes - in case time is wrong due to VM snapshots
sudo timedatectl set-ntp off
sudo timedatectl set-ntp on

# Install Kubectl on the Admin server if not already present
echo verifying kubectl is on Admin server and in path
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
    declare -n n=$node
    serverIP=${n[1]}
    serverInterface=${n[2]}
    serverName=${n[0]}
    echo Sending Root ID Token
    ssh-copy-id root@$serverName
    echo Setting remote hostname
    ssh -t root@$serverName hostnamectl set-hostname $serverName
    echo creating local directory
    mkdir $serverName
    echo sending user-conf.sh
    scp user-conf.sh  root@$serverName:
    ssh root@${n[0]} bash user.conf
    echo Sending $user ID Token 
    ssh-copy-id $user@${n[0]}
done


exit



#Creating the kube-vip.yaml manifest

VIP=$vip
KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases | jq -r ".[0].name")
alias kube-vip="docker run --network host --rm ghcr.io/kube-vip/kube-vip:$KVVERSION"

for node in "${allmasters[@]}"; do
  INTERFACE=${node[2]}

kube-vip manifest daemonset \
    --interface $INTERFACE \
    --address $VIP \
    --inCluster \
    --taint \
    --controlplane \
    --services \
    --arp \
    --leaderElection > ${node[0]}/kube-vip.yaml
done

