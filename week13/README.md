# IPSec VPN + BGP Assessment

## GCP HA VPN / Cloud Router / RFC Review

1. Question: According to RFC 4301, what is the primary purpose of IPSec?

B. To secure IP communications through authentication and encryption 

Please provide a screenshot of where IPSec VPN was configured in your GCP console.

2. Question: According to RFC 7296, which protocol version is used for modern IKE negotiation?

C. IKEv2

Please provide a screenshot showing where IKE version was configured in your VPN tunnel.

3. Question: Which UDP port is primarily used for IKE / ISAKMP negotiations?

B. UDP 500

Please provide a screenshot of your firewall or VPN tunnel configuration showing UDP 500 usage.

4. Question: According to RFC 3948, which UDP port is commonly used for NAT Traversal (NAT-T)?

C. UDP 4500

Please provide a screenshot of your tunnel configuration showing NAT-T related settings or active tunnel status.

5. Question: What is the primary purpose of a Pre-Shared Key (PSK) in IPSec?

B. To authenticate VPN peers 

Please provide a screenshot showing where the PSK was configured in your VPN tunnel setup.

6. Question: Which IPSec component is responsible for encrypting data traffic?

B. ESP

Please provide a screenshot of your tunnel configuration showing ESP or encryption settings.

7. Question: What is the purpose of the Cloud Router in GCP?

C. Exchange BGP routing information 

Please provide a screenshot of your Cloud Router configuration.

8. Question: Which RFC defines the Encapsulating Security Payload (ESP)?

A. RFC 4303 

Please provide a screenshot showing IPSec tunnel encryption settings.

9. Question: Which protocol and port are used by BGP?

B. TCP 179

Please provide a screenshot showing your BGP session configuration.

10. Question: What is the purpose of the 169.254.x.x addresses used in HA VPN BGP sessions?

C. Link-local BGP peer communication 

Please provide a screenshot showing your BGP peer IP addresses.

11. Question: According to RFC 4271, what is the purpose of BGP?

B. Dynamically exchange routing information 

Please provide a screenshot showing learned or advertised BGP routes.

12. Question: What is the most common cause of Phase 1 IPSec failures?

C. PSK mismatch

Please provide a screenshot showing your VPN tunnel status page.

13. Question: Which of the following is typically configured on both VPN peers?

C. Matching encryption settings 

Please provide a screenshot showing your Phase 1 or tunnel cryptographic configuration.

14. Question: Which GCP component creates the public IP addresses used by the VPN tunnels?

B. HA VPN Gateway

Please provide a screenshot showing the external IPs assigned to your HA VPN Gateway.

15. Question: What BGP session state indicates successful route exchange?

D. Established

Please provide a screenshot showing your BGP session state.

16. Question: Which IPSec protocol uses IP Protocol 50?

B. ESP

Please provide a screenshot or CLI output showing active IPSec traffic or tunnel details.

17. Question: Why do companies commonly deploy dual HA VPN tunnels?

B. For redundancy and failover 

Please provide a screenshot showing both VPN tunnels configured in GCP.

18. Question: What is the primary purpose of NAT Traversal (NAT-T)?

C. Allow IPSec traffic through NAT devices

Please provide a screenshot showing tunnel configuration or firewall rules related to NAT-T.

19. Question: Which of the following best describes a Security Association (SA)?

B. A set of agreed IPSec security parameters

Please provide a screenshot showing your VPN tunnel parameters or IPSec settings.

20. Question: What is the correct order of IPSec and BGP establishment?

B. IKE Phase 1 → IPSec Phase 2 → BGP

Please provide a screenshot showing both tunnel establishment and BGP peer status in your console.

## Explain the difference between classic and HA VPN in detail.

- Classic VPN is a single zone deployment with only one active tunnel. That means all traffic runs in one single tunnel to the peer network. That also means that there is no failover if the tunnel was to go down.
- HA VPN Gateways are deployed in multiple aones and contain two active tunnels. This gives the tunnel an automatic failover in case anything happens to one of them. This also comes with a higher service level agreement but it increases the cost due to the fact that more resources are being used.
- https://gcpstudyhub.com/blog/cloud-vpn-for-the-pca-exam-classic-vs-ha-gateway
- https://docs.cloud.google.com/network-connectivity/docs/vpn/concepts/overview