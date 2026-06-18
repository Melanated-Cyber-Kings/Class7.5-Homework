# IPSec VPN + BGP Assessment

## GCP HA VPN / Cloud Router / RFC Review

---

# 1

Question: According to RFC 4301, what is the primary purpose of IPSec?

A. To replace DNS servers
####  Answer       B. To secure IP communications through authentication and encryption
C. To accelerate TCP throughput
D. To replace BGP routing

Please provide a screenshot of where IPSec VPN was configured in your GCP console.
![alt text](image.png)

---

# 2

Question: According to RFC 7296, which protocol version is used for modern IKE negotiation?

A. IKEv0
B. IKEv1
#### Answer C. IKEv2
D. ESPv2

Please provide a screenshot showing where IKE version was configured in your VPN tunnel.
![alt text](image-1.png)
---

# 3

Question: Which UDP port is primarily used for IKE / ISAKMP negotiations?

A. UDP 179
#### Answer B. UDP 500
C. UDP 443
D. UDP 3389

Please provide a screenshot of your firewall or VPN tunnel configuration showing UDP 500 usage.
![alt text](image-2.png)
---

# 4

Question: According to RFC 3948, which UDP port is commonly used for NAT Traversal (NAT-T)?

A. UDP 22
B. UDP 80
#### Answer C. UDP 4500
D. UDP 161

Please provide a screenshot of your tunnel configuration showing NAT-T related settings or active tunnel status.

---

# 5

Question: What is the primary purpose of a Pre-Shared Key (PSK) in IPSec?

A. To assign BGP routes
#### Answer B. To authenticate VPN peers
C. To encrypt DNS traffic
D. To replace ESP encryption

Please provide a screenshot showing where the PSK was configured in your VPN tunnel setup.


---

# 6

Question: Which IPSec component is responsible for encrypting data traffic?

A. AH
#### Answer B. ESP
C. BGP
D. ICMP

Please provide a screenshot of your tunnel configuration showing ESP or encryption settings.
![alt text](image-11.png)
---

# 7

Question: What is the purpose of the Cloud Router in GCP?

A. Encrypt traffic
B. Replace the VPN Gateway
#### Answer C. Exchange BGP routing information
D. Perform DNS resolution

Please provide a screenshot of your Cloud Router configuration.
![alt text](image-12.png)
---

# 8

Question: Which RFC defines the Encapsulating Security Payload (ESP)?

#### Answer A. RFC 4303
B. RFC 4271
C. RFC 1918
D. RFC 1035

Please provide a screenshot showing IPSec tunnel encryption settings.

---

# 9

Question: Which protocol and port are used by BGP?

A. UDP 500
#### Answer B. TCP 179
C. TCP 443
D. UDP 161

Please provide a screenshot showing your BGP session configuration.
![alt text](image-10.png)
---

# 10

Question: What is the purpose of the 169.254.x.x addresses used in HA VPN BGP sessions?

A. Public Internet routing
B. DNS failover
#### Answer C. Link-local BGP peer communication
D. DHCP assignment

Please provide a screenshot showing your BGP peer IP addresses.
![alt text](image-9.png)
---

# 11

Question: According to RFC 4271, what is the purpose of BGP?

A. Encrypt VPN traffic
#### Answer B. Dynamically exchange routing information
C. Replace TCP
D. Manage DNS records

Please provide a screenshot showing learned or advertised BGP routes.
![alt text](image-8.png)
---

# 12

Question: What is the most common cause of Phase 1 IPSec failures?

A. MTU mismatch
B. Incorrect VM subnet
#### Answer C. PSK mismatch
D. DNS timeout

Please provide a screenshot showing your VPN tunnel status page.
![alt text](image-7.png)
---

# 13

Question: Which of the following is typically configured on both VPN peers?

A. Different PSKs
B. Different BGP peer IPs on same side
#### Answer C. Matching encryption settings
D. Random ASN values

Please provide a screenshot showing your Phase 1 or tunnel cryptographic configuration.

---

# 14

Question: Which GCP component creates the public IP addresses used by the VPN tunnels?

A. Cloud DNS
#### Answer B. HA VPN Gateway
C. Cloud NAT
D. VPC Firewall

Please provide a screenshot showing the external IPs assigned to your HA VPN Gateway.
![alt text](image-6.png)
---

# 15

Question: What BGP session state indicates successful route exchange?

A. Idle
B. Connect
C. Active
#### Answer D. Established

Please provide a screenshot showing your BGP session state.
![alt text](image-5.png)
---

# 16

Question: Which IPSec protocol uses IP Protocol 50?

A. AH
#### Answer B. ESP
C. BGP
D. NAT-T

Please provide a screenshot or CLI output showing active IPSec traffic or tunnel details.

---

# 17

Question: Why do companies commonly deploy dual HA VPN tunnels?

A. To increase DNS speed
#### Answer B. For redundancy and failover
C. To eliminate BGP
D. To disable encryption

Please provide a screenshot showing both VPN tunnels configured in GCP.

---

# 18

Question: What is the primary purpose of NAT Traversal (NAT-T)?

A. Compress VPN traffic
B. Encrypt DNS queries
#### Answer C. Allow IPSec traffic through NAT devices
D. Replace ESP headers

Please provide a screenshot showing tunnel configuration or firewall rules related to NAT-T.

---

# 19

Question: Which of the following best describes a Security Association (SA)?

A. A DNS forwarding table
#### Answer B. A set of agreed IPSec security parameters
C. A static route table
D. A load balancer policy

Please provide a screenshot showing your VPN tunnel parameters or IPSec settings.
![alt text](image-4.png)
---

# 20

Question: What is the correct order of IPSec and BGP establishment?

A. BGP → IPSec → IKE
#### Answer B. IKE Phase 1 → IPSec Phase 2 → BGP
C. NAT-T → DNS → ESP
D. Firewall → DNS → BGP

Please provide a screenshot showing both tunnel establishment and BGP peer status in your console.
![alt text](image-3.png)
---