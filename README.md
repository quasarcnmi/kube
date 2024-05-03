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

[RKE2 Overview illustrations](/assets/img/overview.png)
## Servers

There will be 5 servers active for this demonstration.
Admin Server 
- admin1

Master Servers 
- master1
- master2
- master3

Worker Servers (in RKE often referred to as Agents) 
- worker1



