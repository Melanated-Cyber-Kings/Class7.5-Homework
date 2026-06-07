# Test
# IPSec VPN + BGP Assessment | GCP High Availability VPN / Cloud Router / RFC Review

**Question #1** - According to RFC 4301, what is the primary purpose of IPSec?

A. To replace DNS servers<br/>
B. To secure IP communications through authentication and encryption<br/>
C. To accelerate TCP throughput<br/>
D. To replace BGP routing<br/>

*Please provide a screenshot of where IPSec VPN was configured in your GCP console.*
<br/>
<br/>

**Question #2** - According to RFC 7296, which protocol version is used for modern IKE negotiation?

A. IKEv0<br/>
B. IKEv1<br/>
C. IKEv2<br/> 
D. ESPv2<br/>

*Please provide a screenshot showing where IKE version was configured in your VPN tunnel.*
<br/>
<br/>

**Question #3** - Which UDP port is primarily used for IKE / ISAKMP negotiations?

A. UDP 179<br/>
B. UDP 500<br/> 
C. UDP 443<br/> 
D. UDP 3389<br/>
<br/>
<br/>

*Please provide a screenshot of your firewall or VPN tunnel configuration showing UDP 500 usage.*



**Question #4** - According to RFC 3948, which UDP port is commonly used for NAT Traversal (NAT-T)?

A. UDP 22<br/> 
B. UDP 80<br/> 
C. UDP 4500<br/> 
D. UDP 161<br/>

*Please provide a screenshot of your tunnel configuration showing NAT-T related settings or active tunnel status.*
<br/>
<br/>

**Question #5** - What is the primary purpose of a Pre-Shared Key (PSK) in IPSec?

A. To assign BGP routes<br/> 
B. To authenticate VPN peers<br/> 
C. To encrypt DNS traffic<br/>
D. To replace ESP encryption<br/>

*Please provide a screenshot showing where the PSK was configured in your VPN tunnel setup.*

**Question #6** - Which IPSec component is responsible for encrypting data traffic?

A. AH<br/>
B. ESP<br/> 
C. BGP<br/>
D. ICMP<br/>

*Please provide a screenshot of your tunnel configuration showing ESP or encryption settings.*
<br/>
<br/>

**Question #7** - What is the purpose of the Cloud Router in GCP?

A. Encrypt traffic<br/>
B. Replace the VPN Gateway<br/> 
C. Exchange BGP routing information<br/> 
D. Perform DNS resolution<br/>

*Please provide a screenshot of your Cloud Router configuration.*
<br/>
<br/>

**Question #8** - Which RFC defines the Encapsulating Security Payload (ESP)?

A. RFC 4303<br/> 
B. RFC 4271<br/> 
C. RFC 1918<br/> 
D. RFC 1035<br/>

*Please provide a screenshot showing IPSec tunnel encryption settings.*
<br/>
<br/>

**Question #9** - Which protocol and port are used by BGP?

A. UDP 500<br/> 
B. TCP 179<br/>
C. TCP 443<br/>
D. UDP 161<br/>

*Please provide a screenshot showing your BGP session configuration.*
<br/>
<br/>

**Question #10** - What is the purpose of the 169.254.x.x addresses used in HA VPN BGP sessions?

A. Public Internet routing<br/>
B. DNS failover<br/> 
C. Link-local BGP peer communication ✅<br/> 
D. DHCP assignment<br/>

*Please provide a screenshot showing your BGP peer IP addresses.*
<br/>
<br/>

**Question #11** - According to RFC 4271, what is the purpose of BGP?

A. Encrypt VPN traffic<br/> 
B. Dynamically exchange routing information<br/> 
C. Replace TCP<br/> 
D. Manage DNS records<br/>

*Please provide a screenshot showing learned or advertised BGP routes.*
<br/>
<br/>

**Question #12** - What is the most common cause of Phase 1 IPSec failures?

A. MTU mismatch<br/>
B. Incorrect VM subnet<br/> 
C. PSK mismatch<br/>
D. DNS timeout<br/>

*Please provide a screenshot showing your VPN tunnel status page.*
<br/>
<br/>

**Question #13** - Which of the following is typically configured on both VPN peers?

A. Different PSKs<br/>
B. Different BGP peer IPs on same side<br/> 
C. Matching encryption settings<br/>
D. Random ASN values<br/>

*Please provide a screenshot showing your Phase 1 or tunnel cryptographic configuration.*
<br/>
<br/>

**Question #14** - Which GCP component creates the public IP addresses used by the VPN tunnels?

A. Cloud DNS<br/>
B. HA VPN Gateway ✅<br/> 
C. Cloud NAT<br/> 
D. VPC Firewall<br/>

*Please provide a screenshot showing the external IPs assigned to your HA VPN Gateway.*
<br/>
<br/>

**Question #15** - What BGP session state indicates successful route exchange?

A. Idle<br/>
B. Connect<br/> 
C. Active<br/>
D. Established<br/>

*Please provide a screenshot showing your BGP session state.*
<br/>
<br/>

**Question #16** - Which IPSec protocol uses IP Protocol 50?

A. AH<br/>
B. ESP<br/> 
C. BGP<br/> 
D. NAT-T<br/>

*Please provide a screenshot or CLI output showing active IPSec traffic or tunnel details.*
<br/>
<br/>

**Question #17** - Why do companies commonly deploy dual HA VPN tunnels?

A. To increase DNS speed<br/>
B. For redundancy and failover<br/> 
C. To eliminate BGP<br/> 
D. To disable encryption<br/>

*Please provide a screenshot showing both VPN tunnels configured in GCP.*
<br/>
<br/>

**Question #18** - What is the primary purpose of NAT Traversal (NAT-T)?

A. Compress VPN traffic<br/>
B. Encrypt DNS queries<br/>
C. Allow IPSec traffic through NAT devices<br/> 
D. Replace ESP headers<br/>

*Please provide a screenshot showing tunnel configuration or firewall rules related to NAT-T.*
<br/>
<br/>

**Question #19** - Which of the following best describes a Security Association (SA)?

A. A DNS forwarding table<br/>
B. A set of agreed IPSec security parameters<br/> 
C. A static route table<br/> 
D. A load balancer policy<br/>

*Please provide a screenshot showing your VPN tunnel parameters or IPSec settings.*
<br/>
<br/>

**Question #20** - What is the correct order of IPSec and BGP establishment?

A. BGP → IPSec → IKE<br/>
B. IKE Phase 1 → IPSec Phase 2 → BGP<br/> 
C. NAT-T → DNS → ESP<br/> 
D. Firewall → DNS → BGP<br/>

*Please provide a screenshot showing both tunnel establishment and BGP peer status in your console.*
<br/>
<br/>