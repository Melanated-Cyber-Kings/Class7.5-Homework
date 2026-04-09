[GOOGLE CLOUD (GCP) MASTERCLASS: GCP LIVE PROJECTS]


-Section 10: Virtual Private Cloud (VPC) Network in GCP-


![alt text](<cloud architecture example-1.png>)

192.168.x.0 = my default network

192.168.[20].0/24 = main network

DON'T USE 0!!!
DON'T USE 1 EITHER!!!




--Role of IP Addresses in GCP--


Each VM MUST HAVE AN ASSOCIATED IP Address. An internal IP address an an external IP address.

The internal IP address is used to communicate between instances in the SAME VPC NETWORK.

The external IP address is used to communicate with instances in OTHER NETWORKS or THE INTERNET. 

Internal IPs are ephemeral/changed on restart and etc.

External IPs can be static IP addresses, if needed.

Subnets can have primary and secondary CIDR range.




--Lab: VPC IPs Distribution--

Created VM Instances w/ Static IPs

![
](<vpc ip distributions.png>)


Static IP Addresses

![
](<static ip addresses.png>)



--Firewalls in a VPC--

Firewall rules let you allow or deny traffic to and from your virtual machine (VM) instances based on a configuration that you specify.

Firewall rules are defined at the network level, connections are allowed or denied on a per-instance basis.

Users can create or modify Google Cloud firewall rules by using the Google Cloud Console, gcloud command-line tool, and REST API. 






--LAB: Network Firewalls in GCP--

![alt text](<vpc & subnets.png>)


![alt text](<vpc firewall rules.png>)


![alt text](<successful ping into subnet2.png>)


![alt text](<unsuccessful ping into subnet1 due to created firewall rule.png>)




--LAB: Cloud VPN & VPN Tunnels--



Error: Cloud Shell is not loading, will retry this tutorial again soon!









--LAB: Cloud Routers for Routing in GCP--


Will come back to this!!!






[GOOGLE PROFESSIONAL CLOUD SECURITY ENGINEER CERTIFICATION: SECTION 13]





--HANDS ON: CREATE AUTO MODE VPC--


--HANDS ON: CREATE VIRTUAL MACHINE WITH ALL SUBNETS--


--HANDS ON: CREATE FIREWALL RULE - SSH--


--HANDS ON: INTERNAL VS EXTERNAL IP ADDRESS--


--HANDS ON: STATIC VS EPHEMERAL IP ADDRESS-- 