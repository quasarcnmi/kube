# Kubernetes HA Install procedure

This is an isntall of the RKE2 Kubernetes Cluster

I found that this version of Kubernetes install is more straight forward
and flexible.  This apparently is the more secure version of Kubernetes from the SUSE Rancher Company .

I have borrowed some of the functions and shell snippets from [Jim's Garage](https://youtube.com/@jims-garage).

We will be using [Kube-VIP](https://kube-vip.io/docs/)  for the load balancer.

For our A records we install a DNS server on the Admin1 server it will serve our VPC needs. This was constructed on 
Linode based VM's.

We are not using cloud balancers or any other external application, in order to simulate a cold metal build.



