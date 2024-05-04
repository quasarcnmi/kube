#!/bin/bash
echo ======================
echo Customizing for MODA
echo ======================
# Set the IP addresses of the admin, masters, and workers nodes
export admin=(admin1 10.0.0.6 eth0)
export master1=(master1 10.0.0.2 eth0)
export master2=(master2 10.0.0.3 eth0)
export master3=(master3 10.0.0.4 eth0)
export worker1=(worker1 10.0.0.5 eth0)
export vip=10.0.0.10
# User of remote machines
export user=quasar

export all=($master1 $master2 $master3 $worker1)




for node in "${all[@]}"; do
    declare -n n=$node

#    ssh-copy-id root@${n[1]} 
#    ssh -t root@${n[1]} hostnamectl set-hostname ${n[0]}
    
     scp user.conf  root@${n[1]}:
     ssh root@${n[1]} bash user.conf
     echo $user@${n[1]}
     ssh-copy-id $user@${n[1]}
done