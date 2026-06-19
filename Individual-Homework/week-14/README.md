## Google Cloud Platform Multi-Site Virtual Private Network 
This repository continues the planning and deployment of virtual private network (VPN) architectures and services utilized by various cloud service providers. Focus remains on GCP, but other cloud service providers (e.g. AWS) use of external connectivity leveraging IPSec encryption was explored.

Review of core network services like BGP, IPSec, encryption algorithms, and encryption key management was discussed and reviewed.

A comparison between GCP High-Availability VPN services, Cloud Routers, multiples tunnels over multiple interfaces and network paths was accomplished.  Details of the comparison can be found in the file named NCC-HAVPN-comparison.md.

Academic review included GCP Network Connectivity Center and Network Intelligence Center. 

Hands-on group study included going beyond assigned task of deployment of a HA VPN using two partners (cross-account).

The group also deployed a multi-cloud HA VPN connecting GCP VPC in the UK (London) and AWS VPC in Europe (Frankfurt). Deployment was successful using separate service provider accounts. AWS VPN was used with BGP-based tunnels. Details are in the runbook.

A group runbook was created to provide guidance to deploy a GCP to GCP cloud deployment.

References

•	https://docs.cloud.google.com/network-connectivity/docs/router/how-to/configuring-bgp
•	https://docs.cloud.google.com/network-connectivity/docs/router/concepts/key-terms
•	https://docs.cloud.google.com/network-connectivity/docs/router/concepts/how-cloud-router-works
•	https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn2
•	https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/configuring-firewall-rules
•	https://docs.cloud.google.com/network-connectivity/docs/network-connectivity-center/concepts/overview
•	https://cloud.google.com/network-intelligence-center?hl=en
•	https://docs.cloud.google.com/iam/docs/creating-custom-roles
•	https://docs.cloud.google.com/network-connectivity/docs/vpn/tutorials/create-ha-vpn-connections-google-cloud-aws
