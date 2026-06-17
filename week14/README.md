Week 14: Secure Cross-Network Data Transit & Observability
HA VPN vs. Network Connectivity Center (NCC)
While these services serve different roles in your architecture, they achieve the same high-level outcomes: secure data in transit, high availability (HA), and reliable, encrypted transmission from source to destination.

1. HA VPN: The Secure Resilient Pipeline
Summary: HA VPN is a high-availability, fault-tolerant IPsec VPN service that acts like a secure, encrypted pipeline between two endpoints.

Use Case: Use this when you have sensitive data in transit and require a robust, enterprise-grade connection that automatically handles failover to maintain 99.99% availability.

2. Network Connectivity Center (NCC): The Infrastructure Architect
Summary: Network Connectivity Center (NCC) is an orchestration framework that acts like your "furniture assembly" space and instruction manual. It allows you to organize multiple network "spokes" (like VPCs, VPNs, and Interconnects) into a centralized "hub."

Use Case: Use this when transitioning from a simple Proof of Concept (PoC) to a complex, multi-VPC topology. It allows you to visualize and manage how all your network components connect, ensuring your routing architecture is scalable and organized as you expand beyond a single availability zone.

3. Network Intelligence Center (NIC): The Control Dashboard
Summary: The Network Intelligence Center (NIC) is your "single pane of glass" for network observability. It provides a comprehensive dashboard to observe, monitor, and troubleshoot your networking infrastructure in one place.

Use Case: Use NIC for proactive network health. Whether you are performing Connectivity Tests to verify if a firewall rule is blocking your traffic, or analyzing topology to diagnose latency, NIC is your go-to "one-stop-shop" for identifying and resolving issues before and after they impact production.

Resources & Documentation
HA VPN Topologies: Used for understanding highly available, fault-tolerant IPsec tunnel configurations.

Network Connectivity Center Overview: Referenced for managing hub-and-spoke network orchestration and complex topologies.

Network Intelligence Center: Documentation for the centralized observability, monitoring, and troubleshooting dashboard.

Connectivity Tests Overview: Specific guide used for diagnostic testing and verifying path reachability between network endpoints.
