![RKE2 Logo](/assets/img/rke2.jpg)

# Kubernetes RKE2 HA Install procedure

This is an install of the RKE2 Kubernetes Cluster. It has been advertised as being a secure producttion ready industry compliant 
Kubernetes Cluster.

I found that this version of Kubernetes install is more straight forward and less cumbersome as a kubeadm build. 


Along with the install documentation the [RKE2 Documentation](https://docs.rke2.io/), I have borrowed some of the functions and shell snippets from  [Jim's Garage](https://youtube.com/@jims-garage).

We will be using [Kube-VIP](https://kube-vip.io/docs/) for the service load balancer as well as the Cloud Balancer.

For our A records we installed a [DNS server](https://technitium.com/dns/) on the Admin1 server it will serve our VPC needs. This was constructed on a [Linode](https://www.linode.com/) cloud service.

In order to simulate a cold metal build, We are not using cloud balancers or any other cloud application.
## RKE2 System Overview

![RKE2 Overview illustrations](/assets/img/overview.png)
## Servers

There will be 5 servers active for this example.

Admin Server  - This is where we can work in our environment and create and manage the cluster. I will also use it for any misc containers I need to put into the environment, i.e., DNS server, extra load balancer etc. 
- admin1

Master Servers 
- master1
- master2
- master3

Worker Servers (in RKE often referred to as Agents) 
- worker1

## Install Docker on Admin1 
Docker is not an absolute requirement for building the cluster, it was necessary when building an isolated environment on a cloud provider. 
It comes in handy when I need to develop the manifest for ***kube-vip***.

- Remove any previous installs
```
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```
We are using the Rocky Linux Distribution which is closer than Centos to RHEL.

- Install Docker
```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker --now

```
 - Create a non-root user

   - add this user to the wheel and docker groups
   - Reboot VM
- DNS Server
   - If not available, create a DNS server to serve the VM's and define the VIP IP. A sample [docker-compose.yml](/docker-compose.yml) will put a DNS service on the `Admin1` server. Use that IP for the `/etc/resolv.conf` entries on all servers. Our example uses the domain ***moda.net***

## Build the Nodes
Our objectives are: 
- Ensure we have a non prod user set up on nodes. This user must also have sudo rights for each node membe.
- setup the variables in the rke2-install.sh script
- We will create a Kube-Vip manifest file which will be custom for each of the master nodes. In the case of the Ethernet adapters not being assigned the same port.
- Initialize the cluster on the first master node
- Files will be copied back to the admin server.
- The script will then create a install script file and place it in each of the other node
- Go to each node - execute the scripts and it should work!

After cloning this repo - open the [***set-env.sh***](set-env.sh)  script.

Edit the values to customize for your environment.

This script will set your non-root user access for the entire cluster. 

Once the script has completed and exits, it will have exported the variables 
into the current shell. 



