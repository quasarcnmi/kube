
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

# Step 8: Install Metallb
echo Deploying Metal LB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
kubectl wait --namespace metallb-system \
                --for=condition=ready pod \
                --selector=component=controller \
                --timeout=1800s
kubectl apply -f ipAddressPool.yaml
kubectl apply -f l2Advertisement.yaml
echo #
echo #
echo #
echo #
echo Installation complete
echo #
echo #
echo #
echo #
