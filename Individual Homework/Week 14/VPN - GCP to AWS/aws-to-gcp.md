# AWS ↔ GCP HA VPN Console Runbook

## General Class Version

Use this guide to build a clean **GCP London VPC + HA VPN** and connect it to **AWS us-east-1** as a **Non-Google Cloud peer**.

For the AWS↔GCP HA VPN pattern in this lab, use:

```text
2 AWS Site-to-Site VPN connections
= 4 AWS VPN tunnels total
= 4 GCP VPN tunnels total
```

Do **not** try to force this into one AWS VPN connection or two total tunnels. Each AWS Site-to-Site VPN connection gives two tunnels, and the GCP-to-AWS HA VPN pattern uses four peer interfaces/tunnels.

Build this in a **new clean lab VPC** unless your instructor explicitly tells you to reuse an existing environment. Reusing a half-broken gateway/VPC is how bad peer selections, stale BGP values, and route propagation mistakes survive.

---

# 0. Lab value sheet

Use these as the class/default values unless your instructor gave different ones.

## GCP side

| Item           | Value                  |
| -------------- | ---------------------- |
| GCP region     | `europe-west2`         |
| GCP zone       | `europe-west2-a`       |
| VPC            | `aws-london-vpc`       |
| Subnet         | `subnet-london-aws`    |
| Subnet CIDR    | `10.73.2.0/24`         |
| Test VM        | `london-aws`           |
| VM private IP  | `10.73.2.10`           |
| HA VPN gateway | `ha-vpn-gw-london-aws` |
| Cloud Router   | `cr-london-aws`        |
| GCP ASN        | `65011`                |

## AWS side

| Item                    | Value                  |
| ----------------------- | ---------------------- |
| AWS region              | `us-east-1`            |
| VPC                     | `vpn-lab-vpc`          |
| VPC CIDR                | `10.65.0.0/16`         |
| Subnet                  | `vpn-lab-subnet-use1a` |
| Subnet CIDR             | `10.65.11.0/24`        |
| Availability Zone       | `us-east-1a`           |
| EC2 instance            | `aws-gcp`              |
| EC2 private IP          | `10.65.11.10`          |
| Virtual Private Gateway | `vgw-aws-gcp-london`   |
| AWS ASN                 | `65012`                |
| Customer gateway 1      | `cgw-gcp-london-if0`   |
| Customer gateway 2      | `cgw-gcp-london-if1`   |
| VPN connection 1        | `vpn-aws-to-gcp-if0`   |
| VPN connection 2        | `vpn-aws-to-gcp-if1`   |

## BGP / inside tunnel CIDRs

Each AWS VPN tunnel needs a unique `/30` inside CIDR from `169.254.0.0/16`.

Do **not** reuse old tunnel ranges from another lab. Do **not** use AWS-reserved blocks. These values are safely separated from common earlier lab examples.

| AWS VPN connection   | Tunnel |       Inside CIDR |     AWS BGP IP |     GCP BGP IP |
| -------------------- | -----: | ----------------: | -------------: | -------------: |
| `vpn-aws-to-gcp-if0` |      1 | `169.254.22.0/30` | `169.254.22.1` | `169.254.22.2` |
| `vpn-aws-to-gcp-if0` |      2 | `169.254.23.0/30` | `169.254.23.1` | `169.254.23.2` |
| `vpn-aws-to-gcp-if1` |      1 | `169.254.24.0/30` | `169.254.24.1` | `169.254.24.2` |
| `vpn-aws-to-gcp-if1` |      2 | `169.254.25.0/30` | `169.254.25.1` | `169.254.25.2` |

Important: after AWS generates the VPN configuration files, those files become the authority. If the downloaded AWS config shows different inside IP assignment, follow the AWS config.

---

# Part A — GCP Console: create the clean London side first

## 1. Create the GCP VPC

1. Go to **VPC network → VPC networks**.
2. Click **Create VPC network**.
3. Name:

```text
aws-london-vpc
```

4. Subnet creation mode:

```text
Custom
```

5. Add subnet:

```text
Name: subnet-london-aws
Region: europe-west2
IPv4 range: 10.73.2.0/24
```

6. Dynamic routing mode:

```text
Global
```

7. Click **Create**.

Use **Global** dynamic routing for the lab so Cloud Router can advertise/learn routes across the VPC cleanly.

---

## 2. Create the GCP test VM

1. Go to **Compute Engine → VM instances**.
2. Click **Create instance**.
3. Name:

```text
london-aws
```

4. Region:

```text
europe-west2
```

5. Zone:

```text
europe-west2-a
```

6. Machine type:

```text
e2-micro
```

7. Boot disk:

```text
Debian 12
```

8. Open **Advanced options → Networking**.
9. Network tags:

```text
vpn-lab
```

10. Network interface:

```text
Network: aws-london-vpc
Subnetwork: subnet-london-aws
Primary internal IPv4 address: Custom
Internal IP: 10.73.2.10
```

11. Management → Automation → Startup script:

```bash
#!/bin/bash
apt-get update
apt-get install -y nginx
echo london-aws > /var/www/html/index.html
```

12. Click **Create**.

---

## 3. Create GCP firewall rules

Go to:

```text
VPC network → Firewall → Create firewall rule
```

### Rule 1 — allow AWS private CIDR into the GCP VM

```text
Name: london-allow-from-aws
Network: aws-london-vpc
Direction: Ingress
Action: Allow
Targets: Specified target tags
Target tag: vpn-lab
Source IPv4 ranges: 10.65.0.0/16
Protocols and ports:
  tcp: 22,80
  icmp
```

This allows the AWS VPC range to SSH, HTTP, and ping the GCP test VM through the VPN.

### Rule 2 — allow IAP SSH into the GCP VM

```text
Name: london-allow-iap-ssh
Network: aws-london-vpc
Direction: Ingress
Action: Allow
Targets: Specified target tags
Target tag: vpn-lab
Source IPv4 ranges: 35.235.240.0/20
Protocols and ports:
  tcp: 22
```

This allows browser/IAP SSH access to the GCP VM without needing a public VM IP.

---

## 4. Create the GCP HA VPN gateway

1. Go to **Hybrid Connectivity → VPN**.
2. Click **Create VPN connection**.
3. Select **VPN setup wizard**.
4. Choose:

```text
High-availability (HA) VPN
```

5. VPN gateway name:

```text
ha-vpn-gw-london-aws
```

6. Network:

```text
aws-london-vpc
```

7. Region:

```text
europe-west2
```

8. IP version:

```text
IPv4
```

9. Stack type:

```text
IPv4 only
```

10. Click **Create and continue**.

---

## 5. Copy the two GCP HA VPN public interface IPs

Go to:

```text
Hybrid Connectivity → VPN → VPN gateways → ha-vpn-gw-london-aws
```

Record both external IPs:

```text
GCP interface 0 external IP = ____________________
GCP interface 1 external IP = ____________________
```

These are public internet-routable IPs assigned to the GCP HA VPN gateway.

Use them later in AWS:

```text
GCP interface 0 external IP → AWS Customer Gateway 1
GCP interface 1 external IP → AWS Customer Gateway 2
```

Do **not** use `169.254.x.x` here.
The `169.254.x.x` addresses are inside tunnel/BGP addresses, not public customer gateway addresses.

---

# Part B — AWS Console: create VPC and test EC2

## 6. Switch AWS region

1. Open the AWS Console.
2. Use the top-right region selector.
3. Choose:

```text
N. Virginia / us-east-1
```

---

## 7. Create the AWS VPC

1. Go to **VPC → Your VPCs**.
2. Click **Create VPC**.
3. Choose:

```text
VPC only
```

4. Name tag:

```text
vpn-lab-vpc
```

5. IPv4 CIDR:

```text
10.65.0.0/16
```

6. Tenancy:

```text
Default
```

7. Click **Create VPC**.

---

## 8. Create the AWS subnet

1. Go to **VPC → Subnets**.
2. Click **Create subnet**.
3. VPC:

```text
vpn-lab-vpc
```

4. Subnet name:

```text
vpn-lab-subnet-use1a
```

5. Availability Zone:

```text
us-east-1a
```

6. IPv4 subnet CIDR block:

```text
10.65.11.0/24
```

7. Click **Create subnet**.

---

## 9. Create the Internet Gateway

This is only for easy EC2 access/testing.
The VPN itself does **not** require an Internet Gateway.

1. Go to **VPC → Internet gateways**.
2. Click **Create internet gateway**.
3. Name:

```text
igw-vpn-lab
```

4. Click **Create internet gateway**.
5. Select:

```text
igw-vpn-lab
```

6. Actions → **Attach to VPC**.
7. Select:

```text
vpn-lab-vpc
```

8. Click **Attach internet gateway**.

---

## 10. Create the public route table

1. Go to **VPC → Route tables**.
2. Click **Create route table**.
3. Name:

```text
rt-vpn-lab-public
```

4. VPC:

```text
vpn-lab-vpc
```

5. Click **Create route table**.
6. Select:

```text
rt-vpn-lab-public
```

7. Routes tab → **Edit routes**.
8. Add route:

```text
Destination: 0.0.0.0/0
Target: igw-vpn-lab
```

9. Save changes.
10. Subnet associations tab → **Edit subnet associations**.
11. Tick:

```text
vpn-lab-subnet-use1a
```

12. Save associations.

---

## 11. Create the AWS Security Group

1. Go to **VPC → Security groups**.
2. Click **Create security group**.
3. Name:

```text
sg-vpn-lab
```

4. Description:

```text
Allow GCP over VPN
```

5. VPC:

```text
vpn-lab-vpc
```

Add these inbound rules:

```text
Type: SSH
Protocol: TCP
Port: 22
Source: 10.73.2.0/24
Description: GCP London private SSH
```

```text
Type: HTTP
Protocol: TCP
Port: 80
Source: 10.73.2.0/24
Description: GCP London HTTP
```

```text
Type: All ICMP - IPv4
Protocol: ICMP
Source: 10.73.2.0/24
Description: GCP London ping
```

For temporary admin SSH from your own machine, add this only if needed:

```text
Type: SSH
Protocol: TCP
Port: 22
Source: My IP
Description: temporary admin SSH
```

Remove the temporary public SSH rule after testing if it is no longer needed.

---

## 12. Launch the AWS EC2 test instance

1. Go to **EC2 → Instances**.
2. Click **Launch instance**.
3. Name:

```text
aws-gcp
```

4. AMI:

```text
Amazon Linux 2023
```

5. Instance type:

```text
t2.micro
```

or:

```text
t3.micro
```

6. Key pair:

```text
Choose existing key pair or create a new one
```

7. Network settings:

```text
VPC: vpn-lab-vpc
Subnet: vpn-lab-subnet-use1a
Auto-assign public IP: Enable
Firewall: Select existing security group
Security group: sg-vpn-lab
```

8. Advanced network configuration:

```text
Primary private IPv4: 10.65.11.10
```

9. Advanced details → User data:

```bash
#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl enable --now httpd
echo aws-gcp > /var/www/html/index.html
```

10. Click **Launch instance**.

---

# Part C — AWS Console: create VPN foundation

## 13. Create the Virtual Private Gateway

1. Go to **VPC → Virtual private gateways**.
2. Click **Create virtual private gateway**.
3. Name tag:

```text
vgw-aws-gcp-london
```

4. ASN:

```text
Custom ASN
65012
```

5. Click **Create virtual private gateway**.
6. Select:

```text
vgw-aws-gcp-london
```

7. Actions → **Attach to VPC**.
8. VPC:

```text
vpn-lab-vpc
```

9. Click **Attach to VPC**.

The AWS ASN and GCP ASN must be different.

This lab uses:

```text
GCP ASN: 65011
AWS ASN: 65012
```

---

## 14. Create Customer Gateway 1 — for GCP interface 0

1. Go to **VPC → Customer gateways**.
2. Click **Create customer gateway**.
3. Name tag:

```text
cgw-gcp-london-if0
```

4. BGP ASN:

```text
65011
```

5. IP address type:

```text
IPv4
```

6. IP address:

```text
Paste GCP HA VPN interface 0 external IP
```

7. Device:

```text
gcp-ha-vpn-if0
```

8. Click **Create customer gateway**.

---

## 15. Create Customer Gateway 2 — for GCP interface 1

1. Go to **VPC → Customer gateways**.
2. Click **Create customer gateway**.
3. Name tag:

```text
cgw-gcp-london-if1
```

4. BGP ASN:

```text
65011
```

5. IP address type:

```text
IPv4
```

6. IP address:

```text
Paste GCP HA VPN interface 1 external IP
```

7. Device:

```text
gcp-ha-vpn-if1
```

8. Click **Create customer gateway**.

---

## 16. Enable VGW route propagation

1. Go to **VPC → Route tables**.
2. Select:

```text
rt-vpn-lab-public
```

3. Open the **Route propagation** tab.
4. Click **Edit route propagation**.
5. Tick:

```text
vgw-aws-gcp-london
```

6. Save.

This allows routes learned through BGP from GCP to propagate into the selected AWS route table.

If the VGW does not appear here, check:

```text
VPC → Virtual private gateways → vgw-aws-gcp-london
```

Expected:

```text
State: attached
Attached VPC: vpn-lab-vpc
```

If it says detached/not associated, attach it to the correct VPC first.

---

# Part D — AWS Console: create two Site-to-Site VPN connections

## 17. Create VPN connection 1 — to GCP HA VPN interface 0

1. Go to **VPC → Site-to-Site VPN connections**.
2. Click **Create VPN connection**.
3. Name tag:

```text
vpn-aws-to-gcp-if0
```

4. Target gateway type:

```text
Virtual private gateway
```

5. Virtual private gateway:

```text
vgw-aws-gcp-london
```

6. Customer gateway:

```text
Existing
```

7. Customer gateway ID:

```text
cgw-gcp-london-if0
```

8. Routing options:

```text
Dynamic — requires BGP
```

9. Pre-shared key storage:

```text
Standard
```

10. Local IPv4 network CIDR:

```text
0.0.0.0/0
```

11. Remote IPv4 network CIDR:

```text
0.0.0.0/0
```

12. Outside IP address type:

```text
Public IPv4
```

13. Tunnel inside IP version:

```text
IPv4
```

### VPN connection 1 — Tunnel 1 options

Expand **Tunnel 1 options** and use:

```text
Inside IPv4 CIDR: 169.254.22.0/30
IKE versions: remove ikev1, keep ikev2 only
Phase 1 encryption algorithms: AES256 only
Phase 2 encryption algorithms: AES256 only
Phase 1 integrity algorithms: SHA2-256 only
Phase 2 integrity algorithms: SHA2-256 only
Phase 1 DH groups: 14 only
Phase 2 DH groups: 14 only
Startup action: Start
Pre-shared key: leave blank / AWS generated
```

### VPN connection 1 — Tunnel 2 options

Expand **Tunnel 2 options** and use:

```text
Inside IPv4 CIDR: 169.254.23.0/30
IKE versions: remove ikev1, keep ikev2 only
Phase 1 encryption algorithms: AES256 only
Phase 2 encryption algorithms: AES256 only
Phase 1 integrity algorithms: SHA2-256 only
Phase 2 integrity algorithms: SHA2-256 only
Phase 1 DH groups: 14 only
Phase 2 DH groups: 14 only
Startup action: Start
Pre-shared key: leave blank / AWS generated
```

Then click:

```text
Create VPN connection
```

---

## 18. Create VPN connection 2 — to GCP HA VPN interface 1

1. Go to **VPC → Site-to-Site VPN connections**.
2. Click **Create VPN connection**.
3. Name tag:

```text
vpn-aws-to-gcp-if1
```

4. Target gateway type:

```text
Virtual private gateway
```

5. Virtual private gateway:

```text
vgw-aws-gcp-london
```

6. Customer gateway:

```text
Existing
```

7. Customer gateway ID:

```text
cgw-gcp-london-if1
```

8. Routing options:

```text
Dynamic — requires BGP
```

9. Pre-shared key storage:

```text
Standard
```

10. Local IPv4 network CIDR:

```text
0.0.0.0/0
```

11. Remote IPv4 network CIDR:

```text
0.0.0.0/0
```

12. Outside IP address type:

```text
Public IPv4
```

13. Tunnel inside IP version:

```text
IPv4
```

### VPN connection 2 — Tunnel 1 options

```text
Inside IPv4 CIDR: 169.254.24.0/30
IKE versions: ikev2 only
Phase 1 encryption algorithms: AES256 only
Phase 2 encryption algorithms: AES256 only
Phase 1 integrity algorithms: SHA2-256 only
Phase 2 integrity algorithms: SHA2-256 only
Phase 1 DH groups: 14 only
Phase 2 DH groups: 14 only
Startup action: Start
Pre-shared key: leave blank / AWS generated
```

### VPN connection 2 — Tunnel 2 options

```text
Inside IPv4 CIDR: 169.254.25.0/30
IKE versions: ikev2 only
Phase 1 encryption algorithms: AES256 only
Phase 2 encryption algorithms: AES256 only
Phase 1 integrity algorithms: SHA2-256 only
Phase 2 integrity algorithms: SHA2-256 only
Phase 1 DH groups: 14 only
Phase 2 DH groups: 14 only
Startup action: Start
Pre-shared key: leave blank / AWS generated
```

Then click:

```text
Create VPN connection
```

---

## 19. Download both AWS VPN configuration files

For:

```text
vpn-aws-to-gcp-if0
```

do this:

1. Select the VPN connection.
2. Actions → **Download configuration**.
3. Vendor:

```text
Generic
```

4. Platform:

```text
Generic
```

5. Software:

```text
Vendor agnostic
```

if shown.

6. IKE version:

```text
ikev2
```

if shown.

7. Download.

Repeat the same process for:

```text
vpn-aws-to-gcp-if1
```

These downloaded AWS files contain the values required to build the matching GCP tunnels.

---

## 20. Extract the AWS-generated tunnel values

You need:

```text
4 AWS outside public IPs
4 pre-shared keys
4 AWS BGP IPs
4 GCP/customer-side BGP IPs
```

### From `vpn-aws-to-gcp-if0`

Record:

```text
AWS outside IP 1 = VPN connection 1 / Tunnel 1 / Virtual Private Gateway outside IP
AWS outside IP 2 = VPN connection 1 / Tunnel 2 / Virtual Private Gateway outside IP

PSK 1 = VPN connection 1 / Tunnel 1 pre-shared key
PSK 2 = VPN connection 1 / Tunnel 2 pre-shared key
```

Expected mapping if you used the values above:

```text
Tunnel 1:
AWS BGP IP: 169.254.22.1
GCP BGP IP: 169.254.22.2

Tunnel 2:
AWS BGP IP: 169.254.23.1
GCP BGP IP: 169.254.23.2
```

### From `vpn-aws-to-gcp-if1`

Record:

```text
AWS outside IP 3 = VPN connection 2 / Tunnel 1 / Virtual Private Gateway outside IP
AWS outside IP 4 = VPN connection 2 / Tunnel 2 / Virtual Private Gateway outside IP

PSK 3 = VPN connection 2 / Tunnel 1 pre-shared key
PSK 4 = VPN connection 2 / Tunnel 2 pre-shared key
```

Expected mapping if you used the values above:

```text
Tunnel 3:
AWS BGP IP: 169.254.24.1
GCP BGP IP: 169.254.24.2

Tunnel 4:
AWS BGP IP: 169.254.25.1
GCP BGP IP: 169.254.25.2
```

---

# Part E — GCP Console: create AWS as the Non-Google Cloud peer

## 21. Create the external peer VPN gateway in GCP

Back in GCP Console:

1. Go to **Hybrid Connectivity → VPN**.
2. Continue the HA VPN wizard for:

```text
ha-vpn-gw-london-aws
```

or create tunnels against that existing HA VPN gateway.

3. Under **Peer VPN gateway**, choose:

```text
On-prem or Non Google Cloud
```

This is correct because AWS is the peer.

4. Click **Create new peer VPN gateway**.
5. Name:

```text
peer-aws-vgw-use1
```

6. IP version:

```text
IPv4
```

7. Interfaces:

```text
Four interfaces
```

8. Enter the AWS outside public IPs from the downloaded AWS configs:

```text
Interface 0 IP address: AWS outside IP 1
Interface 1 IP address: AWS outside IP 2
Interface 2 IP address: AWS outside IP 3
Interface 3 IP address: AWS outside IP 4
```

9. Click **Create**.

Important: these are the AWS outside public tunnel IPs, not the AWS EC2 private IP and not the GCP HA VPN IPs.

---

## 22. Create or select the GCP Cloud Router

When prompted for routing:

1. Routing option:

```text
Dynamic — BGP
```

2. Cloud Router:

```text
Create new router
```

3. Name:

```text
cr-london-aws
```

4. ASN:

```text
65011
```

5. Click **Create**.

---

## 23. Create the four GCP VPN tunnels

Use:

```text
IKE version: IKEv2
```

Use one consistent cipher set across all tunnels.

### Tunnel 1

```text
Name: tunnel-gcp-to-aws-if0-t1
GCP HA VPN interface: 0
Peer external gateway: peer-aws-vgw-use1
Peer external gateway interface: 0
IKE version: IKEv2
PSK: PSK 1 from AWS config
```

Custom ciphers:

```text
Phase 1 encryption: AES-CBC-256 / AES256
Phase 1 integrity: HMAC-SHA2-256-128 / SHA2-256
Phase 1 PRF: PRF-HMAC-SHA2-256
Phase 1 DH group: Group 14

Phase 2 encryption: AES-CBC-256 / AES256
Phase 2 integrity: HMAC-SHA2-256-128 / SHA2-256
Phase 2 PFS group: Group 14
```

BGP session:

```text
Name: bgp-gcp-to-aws-if0-t1
Peer ASN: 65012
Cloud Router BGP IP: 169.254.22.2
BGP peer IP: 169.254.22.1
```

---

### Tunnel 2

```text
Name: tunnel-gcp-to-aws-if0-t2
GCP HA VPN interface: 0
Peer external gateway: peer-aws-vgw-use1
Peer external gateway interface: 1
IKE version: IKEv2
PSK: PSK 2 from AWS config
```

Use the same custom cipher set as Tunnel 1.

BGP session:

```text
Name: bgp-gcp-to-aws-if0-t2
Peer ASN: 65012
Cloud Router BGP IP: 169.254.23.2
BGP peer IP: 169.254.23.1
```

---

### Tunnel 3

```text
Name: tunnel-gcp-to-aws-if1-t1
GCP HA VPN interface: 1
Peer external gateway: peer-aws-vgw-use1
Peer external gateway interface: 2
IKE version: IKEv2
PSK: PSK 3 from AWS config
```

Use the same custom cipher set.

BGP session:

```text
Name: bgp-gcp-to-aws-if1-t1
Peer ASN: 65012
Cloud Router BGP IP: 169.254.24.2
BGP peer IP: 169.254.24.1
```

---

### Tunnel 4

```text
Name: tunnel-gcp-to-aws-if1-t2
GCP HA VPN interface: 1
Peer external gateway: peer-aws-vgw-use1
Peer external gateway interface: 3
IKE version: IKEv2
PSK: PSK 4 from AWS config
```

Use the same custom cipher set.

BGP session:

```text
Name: bgp-gcp-to-aws-if1-t2
Peer ASN: 65012
Cloud Router BGP IP: 169.254.25.2
BGP peer IP: 169.254.25.1
```

---

# Part F — Verification

## 24. Check GCP tunnel status

In GCP Console, go to:

```text
Hybrid Connectivity → VPN → Cloud VPN tunnels
```

Expected status:

```text
tunnel-gcp-to-aws-if0-t1    Established
tunnel-gcp-to-aws-if0-t2    Established
tunnel-gcp-to-aws-if1-t1    Established
tunnel-gcp-to-aws-if1-t2    Established
```

If a tunnel is not established, check:

```text
PSK matches AWS config
IKE version is IKEv2
Cipher set matches on both sides
Correct GCP HA VPN interface selected
Correct AWS peer gateway interface selected
Correct AWS outside public IP used
```

---

## 25. Check GCP BGP status

In GCP Console, go to:

```text
Hybrid Connectivity → Cloud Routers → cr-london-aws → BGP sessions
```

Expected status:

```text
bgp-gcp-to-aws-if0-t1    Established
bgp-gcp-to-aws-if0-t2    Established
bgp-gcp-to-aws-if1-t1    Established
bgp-gcp-to-aws-if1-t2    Established
```

If the tunnel is up but BGP is down, check:

```text
GCP ASN: 65011
AWS ASN: 65012
Cloud Router BGP IP is the GCP/customer-side inside IP
BGP peer IP is the AWS-side inside IP
Inside /30 CIDRs are unique
Values match the downloaded AWS config
```

---

## 26. Check AWS tunnel status

In AWS Console, go to:

```text
VPC → Site-to-Site VPN connections
```

Open:

```text
vpn-aws-to-gcp-if0
vpn-aws-to-gcp-if1
```

Expected:

```text
vpn-aws-to-gcp-if0 / Tunnel 1: UP
vpn-aws-to-gcp-if0 / Tunnel 2: UP

vpn-aws-to-gcp-if1 / Tunnel 1: UP
vpn-aws-to-gcp-if1 / Tunnel 2: UP
```

---

## 27. Test GCP → AWS

SSH into the GCP VM:

```text
london-aws
```

Use IAP/browser SSH if enabled.

Run:

```bash
ping -c 4 10.65.11.10
curl http://10.65.11.10
```

Expected HTTP output:

```text
aws-gcp
```

---

## 28. Test AWS → GCP

SSH into the AWS EC2 instance:

```text
aws-gcp
```

Run:

```bash
ping -c 4 10.73.2.10
curl http://10.73.2.10
```

Expected HTTP output:

```text
london-aws
```

---

# Troubleshooting decision map

## Tunnel DOWN

Check in this order:

```text
1. Is the GCP HA VPN public IP correctly entered into the AWS Customer Gateway?
2. Is the AWS outside public tunnel IP correctly entered into the GCP external peer gateway?
3. Does the PSK match exactly?
4. Is IKEv2 selected on both sides?
5. Are the cipher settings compatible?
6. Did you select the correct GCP HA VPN interface?
7. Did you select the correct peer external gateway interface?
```

Most common mistake:

```text
Using a 169.254.x.x BGP IP where a public outside IP is required.
```

---

## Tunnel UP but BGP DOWN

Check:

```text
1. AWS ASN and GCP ASN are different.
2. GCP ASN = 65011.
3. AWS ASN = 65012.
4. Cloud Router BGP IP is the GCP/customer-side inside IP.
5. BGP peer IP is the AWS-side inside IP.
6. Inside CIDRs are unique per tunnel.
7. You copied values from the correct AWS VPN config file.
```

Common wrong mapping:

```text
Wrong:
Cloud Router BGP IP: 169.254.22.1
BGP peer IP: 169.254.22.2

Correct:
Cloud Router BGP IP: 169.254.22.2
BGP peer IP: 169.254.22.1
```

In this lab, AWS uses `.1` and GCP uses `.2` for each `/30`.

---

## BGP UP but ping/curl fails

Check:

```text
1. AWS route propagation is enabled on rt-vpn-lab-public.
2. AWS security group allows ICMP/HTTP/SSH from 10.73.2.0/24.
3. GCP firewall allows ICMP/HTTP/SSH from 10.65.0.0/16.
4. The EC2 private IP is actually 10.65.11.10.
5. The GCP VM private IP is actually 10.73.2.10.
6. Nginx/httpd actually installed and running.
```

On GCP VM:

```bash
curl http://localhost
```

Expected:

```text
london-aws
```

On AWS EC2:

```bash
curl http://localhost
```

Expected:

```text
aws-gcp
```

---

# Critical notes

1. **AWS does not need you to reserve static public IPs for the VPN tunnels.**
   AWS generates the outside public tunnel IPs after you create the Site-to-Site VPN connection.

2. **AWS Customer Gateway uses the GCP HA VPN public interface IPs.**
   Use GCP interface 0 and interface 1 external IPs.

3. **GCP external peer gateway uses the AWS outside public tunnel IPs.**
   These come from the downloaded AWS VPN configuration files.

4. **Do not use `169.254.x.x` as a public gateway IP.**
   `169.254.x.x` is for inside tunnel/BGP addressing only.

5. **Use two AWS VPN connections, not one.**
   Each AWS VPN connection gives two tunnels. For this AWS↔GCP HA pattern, the lab uses two AWS VPN connections and four total tunnels.

6. **Do not reuse old BGP values.**
   This runbook uses:

```text
169.254.22.0/30
169.254.23.0/30
169.254.24.0/30
169.254.25.0/30
```

7. **Do not copy another student’s AWS outside IPs or PSKs.**
   Each AWS VPN config file generates unique values.

8. **If your VGW does not appear under route propagation, it is probably not attached to the VPC.**
   Attach `vgw-aws-gcp-london` to `vpn-lab-vpc`, then check the route table again.

9. **If using the default VPC, be extra careful.**
   The runbook assumes a clean VPC. Default VPCs often have existing routes, subnets, gateways, or security groups that make troubleshooting harder.

10. **The AWS downloaded VPN config file is authoritative.**
    The tables above are the intended lab plan, but the final AWS-generated config wins if there is a mismatch.

[1]: https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/connect-ha-vpn-aws-peer-gateway?utm_source=chatgpt.com "Connect HA VPN to AWS peer gateways"

