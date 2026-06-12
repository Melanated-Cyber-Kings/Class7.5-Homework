## GCP Classic VPN Runbook

### Overview

This document provides workflow for two individuals to work in parallel to deploy a Virtual Private Cloud (VPC), Compute Engine instances, Classic VPN, and related infrastructure.

The intent is to provide repeatable steps to assist in understanding site-to-site encryption in an academic environment. 

For this demonstration we use only two sites:

* Germany (DE)
* United Kingdom (UK)

We basically assign:

* Administrator A for the DE Region (europe-west3)
* Administrator B for the UK Region (europe-west2)

### Network Diagram

To be added.

## Administrator A - DE Region Responsibilities

### Step 1 - Create VPC + Subnet

VPC Name: VPC-DE

Subnet Name: subnet-de

Region: europe-west3

CIDR: 10.20.1.0/24

### Step 2 - Create Test VM

VM Name: vm-de

Region: europe-west3

Subnet: subnet-de

Internal IP: auto (10.20.1.x)

Enable HTTP traffic

### Step 3 - Create Classic VPN Gateway

Name: vpn-gw-de

Network: VPC-DE

Region: europe-west3

External IP: Reserve static IP

Note: Share DE public IP with Administrator B

### Step 4 - Create Tunnel (DE → UK)

Tunnel Name: tunnel-de-to-uk

Remote Peer IP: UK gateway public IP

IKE Version: 2

Shared Secret: agreed key

Routing: Static

Remote CIDR: 10.30.1.0/24

Local CIDR: 10.20.1.0/24

### Step 5 - Create Static Route

Name: route-de-to-uk

Destination: 10.30.1.0/24

Next Hop: tunnel-de-to-uk

### Step 6 - Create Firewall Rule

Name: fw-de-from-uk

Direction: Ingress

Source: 10.30.1.0/24

Allow:

* ICMP
* TCP 22 (SSH)
* TCP 80 (HTTP)


## Administrator B - UK Region Responsibilities

### Step 1 - Create VPC + Subnet

VPC Name: VPC-UK

Subnet Name: subnet-uk

Region: europe-west2

CIDR: 10.30.1.0/24

### Step 2 - Create Test VM

VM Name: vm-uk

Region: europe-west2

Subnet: subnet-uk

Internal IP: auto (10.30.1.x)

Enable HTTP traffic

### Step 3 - Create Classic VPN Gateway

Name: vpn-gw-uk

Network: VPC-UK

Region: europe-west2

External IP: Reserve static IP

Note: Share UK public IP with Administrator A

### Step 4 - Create Tunnel (UK → DE)

Tunnel Name: tunnel-uk-to-de

Remote Peer IP: DE gateway public IP

IKE Version: 2

Shared Secret: same key as DE site

Routing: Static

Remote CIDR: 10.20.1.0/24

Local CIDR: 10.30.1.0/24

### Step 5 - Create Static Route

Name: route-uk-to-de

Destination: 10.20.1.0/24

Next Hop: tunnel-uk-to-de


### Step 6 - Create Firewall Rule

Name: fw-uk-from-de

Direction: Ingress

Source: 10.20.1.0/24

Allow:

* ICMP
* TCP 22 (SSH)
* TCP 80 (HTTP)


### Create a GCP IAP Firewall Rule

To allow IAP to connect to your VM instances, create a firewall rule that allows incoming traffic from the IAP IP address range. This rule should allow TCP traffic on ports 22 (SSH) from the IAP IP range.

1. Open the Firewall Rules page.

2. Select a Google Cloud project.

3. On the Firewall Rules page, click **Create firewall rule**.

4. Configure the following settings:

   * Name: `allow-ingress-from-iap`
   * Direction of traffic: Ingress
   * Target: All instances in the network
   * Source filter: IP ranges
   * Source IP ranges: `35.235.240.0/20`
   * Protocols and ports: TCP `22`

5. Click **Create**.

[!NOTE] Associate this rule with the VPC network that contains the VM instances on each end of the VPN tunnel.

References:

- Console: https://docs.cloud.google.com/iap/docs/using-tcp-forwarding#console
- gcloud: https://docs.cloud.google.com/iap/docs/using-tcp-forwarding#gcloud



### Validation Steps

* Verify that Classic VPN tunnel has an established SA. Check in the GCP console under VPN → Tunnels. The status should show as "Established".

* From the DE VM, ping the UK VM's internal IP address (10.30.1.x). This tests connectivity over the VPN tunnel. Substitute the actual internal IP addresses assigned to the VMs.

* From the UK VM, ping the DE VM's internal IP address (10.20.1.x). This tests connectivity over the VPN tunnel. Substitute the actual internal IP addresses assigned to the VMs.

* Can UK and/or DE access a web page running on remote virtual machines?

 As a more realistic test, you can set up a simple web server on each VM by installing a web server and basic web page, and then try to access the web page from the other VM using the internal IP address.

- Run curl http://10.30.1.x (from DE VM) to access the UK VM's web page.
- Run curl http://10.20.1.x (from UK VM) to access the DE VM's web page.


* Can SSH be accessed from either location?
  Try to SSH from one VM to the other using the internal IP addresses. For example:
  
 - From DE VM: ssh user@10.30.1.x (UK VM's internal IP)
 - From UK VM: ssh user@10.20.1.x (DE VM's internal IP) 

If the pings and at least one TCP test (web or SSH) are successful, then the VPN tunnel is working correctly and allowing traffic between the two sites.

## Teardown Steps

Perform the reverse of the deployment steps to clean up the environment:
1. Delete the external IP addresses reserved for the VPN gateways.
2. Delete the VPN tunnels.
3. Delete the VPN gateways.
4. Delete the Compute Engine instances.
5. Delete the firewall rules.
6. Delete the VPC networks.

[!CAUTION] Be sure to check that all resources are deleted to avoid unnecessary expenses. This is especially important for the IP addresses and VPN related resources, as they can get quite expensive if left running.


## References

- https://cloud.google.com/network-connectivity/docs/vpn/concepts/overview
- https://cloud.google.com/network-connectivity/docs/vpn/concepts/topologies
- https://cloud.google.com/network-connectivity/docs/vpn/how-to/classic-static
- https://cloud.google.com/network-connectivity/docs/vpn/how-to/classic-static#add_tunnel
- https://cloud.google.com/network-connectivity/docs/vpn/concepts/routes
