# IPSec VPN + BGP Assessment

## GCP HA VPN / Cloud Router / RFC Review

---

# 1

Question: According to RFC 4301, what is the primary purpose of IPSec?

A. To replace DNS servers
B. To secure IP communications through authentication and encryption
C. To accelerate TCP throughput
D. To replace BGP routing

Answer: B. Per RFC 4301, Section 2.1IPsec is designed to provide interoperable, high quality,
   cryptographically-based security for IPv4 and IPv6. 

Please provide a screenshot of where IPSec VPN was configured in your GCP console.

---

# 2

Question: According to RFC 7296, which protocol version is used for modern IKE negotiation?

A. IKEv0
B. IKEv1
C. IKEv2
D. ESPv2

Answer: C. IKEv2

Please provide a screenshot showing where IKE version was configured in your VPN tunnel.

---

# 3

Question: Which UDP port is primarily used for IKE / ISAKMP negotiations?

A. UDP 179
B. UDP 500
C. UDP 443
D. UDP 3389

Answer: UDP 500

Please provide a screenshot of your firewall or VPN tunnel configuration showing UDP 500 usage.

---

# 4

Question: According to RFC 3948, which UDP port is commonly used for NAT Traversal (NAT-T)?

A. UDP 22
B. UDP 80
C. UDP 4500
D. UDP 161

Answer:  C. UDP 4500 per Section 2.2 IKE Header Format for Port 4500

Please provide a screenshot of your tunnel configuration showing NAT-T related settings or active tunnel status.

---

# 5

Question: What is the primary purpose of a Pre-Shared Key (PSK) in IPSec?

A. To assign BGP routes
B. To authenticate VPN peers
C. To encrypt DNS traffic
D. To replace ESP encryption

Answer: B. To authenticate VPN peers 

Please provide a screenshot showing where the PSK was configured in your VPN tunnel setup.

---

# 6

Question: Which IPSec component is responsible for encrypting data traffic?

A. AH
B. ESP
C. BGP
D. ICMP

Answer:  B. ESP

Please provide a screenshot of your tunnel configuration showing ESP or encryption settings.

---

# 7

Question: What is the purpose of the Cloud Router in GCP?

A. Encrypt traffic
B. Replace the VPN Gateway
C. Exchange BGP routing information
D. Perform DNS resolution

Answer:  C.  Exchange BGP routing information

Please provide a screenshot of your Cloud Router configuration.

---

# 8

Question: Which RFC defines the Encapsulating Security Payload (ESP)?

A. RFC 4303
B. RFC 4271
C. RFC 1918
D. RFC 1035

Answer: A. RFC 4303 

Please provide a screenshot showing IPSec tunnel encryption settings.

---

# 9

Question: Which protocol and port are used by BGP?

A. UDP 500
B. TCP 179
C. TCP 443
D. UDP 161

Answer: B. TCP 179 per RFC 4271, Section 3, BGP listens on TCP port 179.

Please provide a screenshot showing your BGP session configuration.

---

# 10

Question: What is the purpose of the 169.254.x.x addresses used in HA VPN BGP sessions?

A. Public Internet routing
B. DNS failover
C. Link-local BGP peer communication
D. DHCP assignment

Answer: C.  Link-local BGP peer communication

Please provide a screenshot showing your BGP peer IP addresses.

---

# 11

Question: According to RFC 4271, what is the purpose of BGP?

A. Encrypt VPN traffic
B. Dynamically exchange routing information
C. Replace TCP
D. Manage DNS records

Answer: B. Dynamically exchange routing information. RFC 4271, Section 3. The primary function of a BGP speaking system is to exchange network    reachability information with other BGP systems.  This network reachability information includes information on the list of Autonomous Systems (ASes) that reachability information traverses.

Please provide a screenshot showing learned or advertised BGP routes.

---

# 12

Question: What is the most common cause of Phase 1 IPSec failures?

A. MTU mismatch
B. Incorrect VM subnet
C. PSK mismatch
D. DNS timeout

Answer: C. PSK mismatch

Please provide a screenshot showing your VPN tunnel status page.

---

# 13

Question: Which of the following is typically configured on both VPN peers?

A. Different PSKs
B. Different BGP peer IPs on same side
C. Matching encryption settings
D. Random ASN values

Answer: C. Matching encryption settings

Please provide a screenshot showing your Phase 1 or tunnel cryptographic configuration.

---

# 14

Question: Which GCP component creates the public IP addresses used by the VPN tunnels?

A. Cloud DNS
B. HA VPN Gateway
C. Cloud NAT
D. VPC Firewall

Answer: B. HA VPN Gateway

Please provide a screenshot showing the external IPs assigned to your HA VPN Gateway.

---

# 15

Question: What BGP session state indicates successful route exchange?

A. Idle
B. Connect
C. Active
D. Established

Answer: D. Established

Please provide a screenshot showing your BGP session state.

---

# 16

Question: Which IPSec protocol uses IP Protocol 50?

A. AH
B. ESP
C. BGP
D. NAT-T

Answer:  B. ESP 
Reference RFC 4303, Section 2.  The (outer) protocol header (IPv4, IPv6, or Extension) that
   immediately precedes the ESP header SHALL contain the value 50 in its
   Protocol (IPv4) or Next Header (IPv6, Extension) field (see IANA web
   page at http://www.iana.org/assignments/protocol-numbers).

Please provide a screenshot or CLI output showing active IPSec traffic or tunnel details.

---

# 17

Question: Why do companies commonly deploy dual HA VPN tunnels?

A. To increase DNS speed
B. For redundancy and failover
C. To eliminate BGP
D. To disable encryption

Answer: B. For redundancy and failover

Please provide a screenshot showing both VPN tunnels configured in GCP.

---

# 18

Question: What is the primary purpose of NAT Traversal (NAT-T)?

A. Compress VPN traffic
B. Encrypt DNS queries
C. Allow IPSec traffic through NAT devices
D. Replace ESP headers

Answer: C. Allow IPSec traffic through NAT devices

Reference: https://docs.cloud.google.com/network-connectivity/docs/vpn/concepts/overview, [If your peer VPN gateway is behind a firewall rule, you must configure the firewall rule to pass ESP (IPsec) protocol and IKE (UDP 500 and UDP 4500) traffic to it. If the firewall rule provides network address translation (NAT), see UDP encapsulation and NAT-T.]

Please provide a screenshot showing tunnel configuration or firewall rules related to NAT-T.

---

# 19

Question: Which of the following best describes a Security Association (SA)?

A. A DNS forwarding table
B. A set of agreed IPSec security parameters
C. A static route table
D. A load balancer policy

Answer: B. A set of agreed IPSec security parameters

Please provide a screenshot showing your VPN tunnel parameters or IPSec settings.

---

# 20

Question: What is the correct order of IPSec and BGP establishment?

A. BGP → IPSec → IKE
B. IKE Phase 1 → IPSec Phase 2 → BGP
C. NAT-T → DNS → ESP
D. Firewall → DNS → BGP

Answer: B. IKE Phase 1 → IPSec Phase 2 → BGP

Please provide a screenshot showing both tunnel establishment and BGP peer status in your console.

---