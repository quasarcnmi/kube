# Kubernetes HA Install procedure

This is an install of the RKE2 Kubernetes Cluster
![RKE2 Logo](/assets/img/rke2.svg)


I found that this version of Kubernetes install is more straight forward
and flexible.  This apparently is the more secure version of Kubernetes from the SUSE Rancher Company .

I have borrowed some of the functions and shell snippets from [Jim's Garage](https://youtube.com/@jims-garage).

We will be using [Kube-VIP](https://kube-vip.io/docs/)  for the load balancer.

For our A records we install a [DNS server](https://technitium.com/dns/) on the Admin1 server it will serve our VPC needs. This was constructed on 
Linode based VM's.

In order to simulate a cold metal build, We are not using cloud balancers or any other cloud application.

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



