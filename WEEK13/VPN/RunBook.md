# Classic VPN vs HA VPN

#**Classic VPN** gives you one external IP and one tunnel. If that tunnel dies, your connection dies.
**HA VPN** gives you two external IPs and two tunnels running simultaneously. If one fails, traffic automatically shifts to the other. GCP also backs it with a 99.99% SLA vs 99.9% for Classic.

## The Bridge Analogy

Imagine you need to cross a river to get to work every day.

**Classic VPN** is a single bridge. It works fine — until it doesn't. If that bridge closes for maintenance or collapses, you're stuck. No crossing, no work.

**HA VPN** is two bridges side by side. You normally use both. If one closes, you automatically take the other without stopping, without turning back, without even noticing.

---

## The Practical Difference

| | Classic VPN | HA VPN |
|---|---|---|
| External IPs | 1 | 2 |
| Tunnels | 1 | 2 (one per IP) |
| Tunnel failure | Connection drops | Traffic shifts to surviving tunnel |
| GCP SLA | 99.9% | 99.99% |

---

## What 99.9% vs 99.99% Actually Means

- **99.9%** — up to ~8.7 hours of downtime per year
- **99.99%** — up to ~52 minutes of downtime per year

For anything production-grade, I think HA VPN is the right choice.





# GCP HA VPN + BGP Implementation Runbook

**Stack:** HA VPN · Cloud Router · BGP · IKEv2 / IPSec  
**Scope:** Two GCP VPC networks connected via 4 IPSec tunnels with dynamic BGP routing

---

## Architecture Overview

Two isolated VPC networks are joined by a pair of HA VPN gateways. Each gateway exposes two external interfaces (Interface 0 and Interface 1). Four IPSec tunnels — one per interface combination — carry encrypted traffic. Cloud Routers on each side run BGP sessions inside those tunnels, automatically exchanging subnet reachability without static routes.

```
vpc-site-a (10.1.0.0/24)          vpc-site-b (10.2.0.0/24)
  us-central1                          us-east1

 [ha-vpn-gateway-site-a]  <=4 tunnels=>  [ha-vpn-gateway-site-b]
  IF0  IF1                                IF0  IF1

 [cloud-router-site-a]   <==BGP==>   [cloud-router-site-b]
   ASN 65001                               ASN 65002
```

---

## Phase 0 — Environment Setup

### 0.1 Enable Required APIs

In the GCP Console, go to **APIs & Services → Enable APIs and Services** and enable:

- Compute Engine API
- Cloud Router API

Or via Cloud Shell:

```bash
gcloud services enable compute.googleapis.com
```

### 0.2 Set Your Active Project

```bash
gcloud config set project YOUR_PROJECT_ID
```

---

## Phase 1 — Create VPC Networks

### 1.1 VPC Network A

1. Navigate to **VPC networks → Create VPC network**
2. Set:
   - **Name:** `vpc-site-a`
   - **Subnet creation mode:** Custom
3. Add a subnet:
   - **Name:** `subnet-site-a`
   - **Region:** `us-central1`
   - **IP range:** `10.1.0.0/24`
4. Click **Create**

### 1.2 VPC Network B

1. Click **Create VPC network** again
2. Set:
   - **Name:** `vpc-site-b`
   - **Subnet creation mode:** Custom
3. Add a subnet:
   - **Name:** `subnet-site-b`
   - **Region:** `us-east1`
   - **IP range:** `10.2.0.0/24`
4. Click **Create**

> The two VPCs are fully isolated. The VPN tunnels created in Phase 4 are the only bridge between them.

---

## Phase 2 — Create HA VPN Gateways

Each HA VPN gateway automatically allocates **two external IP addresses** (Interface 0 and Interface 1). Record both IPs for each gateway before proceeding.

### 2.1 Gateway for Site A

1. Navigate to **Hybrid Connectivity → Cloud VPN → Create VPN Gateway**
2. Select **High-availability (HA) VPN** and click **Continue**
3. Set:
   - **Name:** `ha-vpn-gateway-site-a`
   - **Network:** `vpc-site-a`
   - **Region:** `us-central1`
   - **IP stack type:** IPv4 (Single stack)
4. Click **Create and Continue**
5. **Record both external IP addresses** shown (Interface 0 and Interface 1)

### 2.2 Gateway for Site B

1. Click **Create VPN Gateway → High-availability (HA) VPN → Continue**
2. Set:
   - **Name:** `ha-vpn-gateway-site-b`
   - **Network:** `vpc-site-b`
   - **Region:** `us-east1`
3. Click **Create and Continue**
4. **Record both external IP addresses**

---

## Phase 3 — Create Cloud Routers

Cloud Routers handle BGP session management and dynamic route advertisement for each VPC.

### 3.1 Cloud Router for Site A

1. Navigate to **Hybrid Connectivity → Cloud Routers → Create Router**
2. Set:
   - **Name:** `cloud-router-site-a`
   - **Network:** `vpc-site-a`
   - **Region:** `us-central1`
   - **Google ASN:** `65001`
3. Click **Create**

### 3.2 Cloud Router for Site B

1. Click **Create Router**
2. Set:
   - **Name:** `cloud-router-site-b`
   - **Network:** `vpc-site-b`
   - **Region:** `us-east1`
   - **Google ASN:** `65002`
3. Click **Create**

> ASNs must be unique per router. 65001 and 65002 are private ASNs from the 64512–65534 range.

---

## Phase 4 — Create VPN Tunnels

### 4.1 Tunnels on Site A

1. Go to **Cloud VPN** and click on `ha-vpn-gateway-site-a`
2. Click **Add VPN Tunnel**
3. Set peer:
   - **Peer VPN gateway type:** Google Cloud
   - **Peer gateway:** `ha-vpn-gateway-site-b`
4. Select **Create 2 tunnels** for high availability
5. Set:
   - **Cloud Router:** `cloud-router-site-a`
   - **IKE version:** IKEv2
   - **IKE pre-shared key:** Click **Generate and copy** — save this value securely
6. Name the tunnels:
   - Tunnel 1: `vpn-tunnel-a-to-b-if0`
   - Tunnel 2: `vpn-tunnel-a-to-b-if1`
7. Click **Create and Continue**

> GCP will immediately prompt you to configure BGP sessions. Do not navigate away — proceed to Phase 5.1 now.

### 4.2 Tunnels on Site B

After completing BGP on Site A (Phase 5.1):

1. Go to `ha-vpn-gateway-site-b` → **Add VPN Tunnel**
2. Set:
   - **Peer gateway:** `ha-vpn-gateway-site-a`
   - **Cloud Router:** `cloud-router-site-b`
   - **IKE version:** IKEv2
   - **IKE pre-shared key:** Use the **exact same PSK** generated in 4.1
3. Name the tunnels:
   - Tunnel 1: `vpn-tunnel-b-to-a-if0`
   - Tunnel 2: `vpn-tunnel-b-to-a-if1`
4. Click **Create and Configure BGP sessions** — proceed to Phase 5.2

---

## Phase 5 — Configure BGP Sessions

BGP sessions run inside the encrypted tunnels using `169.254.x.x` link-local addresses. The address pairs must be exact mirrors across both sides.

### 5.1 BGP Sessions on Site A

Configure immediately after tunnel creation in Phase 4.1:

**Tunnel 1 — `vpn-tunnel-a-to-b-if0`**

| Field | Value |
|---|---|
| BGP session name | `bgp-session-a-to-b-if0` |
| Peer ASN | `65002` |
| Cloud Router BGP IP | `169.254.1.1` |
| BGP peer IP | `169.254.1.2` |

**Tunnel 2 — `vpn-tunnel-a-to-b-if1`**

| Field | Value |
|---|---|
| BGP session name | `bgp-session-a-to-b-if1` |
| Peer ASN | `65002` |
| Cloud Router BGP IP | `169.254.2.1` |
| BGP peer IP | `169.254.2.2` |

Click **Save BGP configuration**.

### 5.2 BGP Sessions on Site B

Configure immediately after tunnel creation in Phase 4.2. The `169.254.x.x` IPs are swapped:

**Tunnel 1 — `vpn-tunnel-b-to-a-if0`**

| Field | Value |
|---|---|
| BGP session name | `bgp-session-b-to-a-if0` |
| Peer ASN | `65001` |
| Cloud Router BGP IP | `169.254.1.2` |
| BGP peer IP | `169.254.1.1` |

**Tunnel 2 — `vpn-tunnel-b-to-a-if1`**

| Field | Value |
|---|---|
| BGP session name | `bgp-session-b-to-a-if1` |
| Peer ASN | `65001` |
| Cloud Router BGP IP | `169.254.2.2` |
| BGP peer IP | `169.254.2.1` |

Click **Save BGP configuration**.

> **Critical:** Each `169.254.x.x` pair must be mirrored precisely. If Site A's Cloud Router BGP IP is `169.254.1.1`, then Site B's BGP peer IP for that tunnel must also be `169.254.1.1`.

---

## Phase 6 — Verify HA VPN and BGP Status

### 6.1 Verify Tunnel Status

1. Navigate to **Cloud VPN**
2. Confirm both tunnels on each gateway show status **Established**
3. Both Interface 0 and Interface 1 tunnels should be green

### 6.2 Verify BGP Route Exchange

1. Go to **Cloud Router → `cloud-router-site-a`**
2. Under **BGP sessions**, confirm both sessions show **Established**
3. Under **Received routes**, confirm `10.2.0.0/24` is present (learned from Site B)
4. Under **Advertised routes**, confirm `10.1.0.0/24` is present
5. Repeat for `cloud-router-site-b` — it should show `10.1.0.0/24` as a received route

> If routes are missing, wait 2–3 minutes after tunnels reach Established. BGP requires the IPSec tunnel to be fully up before starting its TCP session.

---

## Phase 7 — Firewall Rules and Connectivity Test

### 7.1 Create Firewall Rules

GCP VPCs block all traffic by default. Allow ICMP between the two sites:

**Rule for vpc-site-a** (allow pings inbound from Site B):

1. Navigate to **VPC network → Firewall → Create Firewall Rule**
2. Set:
   - **Name:** `allow-icmp-site-a`
   - **Network:** `vpc-site-a`
   - **Direction:** Ingress
   - **Action:** Allow
   - **Targets:** All instances in the network
   - **Source IP ranges:** `10.2.0.0/24`
   - **Protocols and ports:** Other protocols: `icmp`
3. Click **Create**

**Rule for vpc-site-b** (mirror of above):

Repeat with:
- **Name:** `allow-icmp-site-b`
- **Network:** `vpc-site-b`
- **Source IP ranges:** `10.1.0.0/24`

### 7.2 Create Test VMs

**VM in Site A:**

1. Navigate to **Compute Engine → VM instances → Create Instance**
2. Set:
   - **Name:** `vm-site-a`
   - **Region / Zone:** `us-central1 / us-central1-a`
   - **Machine type:** `e2-micro`
   - **Network:** `vpc-site-a`, **Subnet:** `subnet-site-a`
   - **External IP:** None
3. Click **Create**

**VM in Site B:**

Repeat with:
- **Name:** `vm-site-b`
- **Region / Zone:** `us-east1 / us-east1-b`
- **Network:** `vpc-site-b`, **Subnet:** `subnet-site-b`

### 7.3 Test End-to-End Connectivity

1. Note the internal IP of `vm-site-b` (e.g. `10.2.0.3`)
2. Click **SSH** next to `vm-site-a`
3. Run:

```bash
ping -c 4 10.2.0.3
```

Successful ping replies confirm the full IPSec + BGP stack is operational.

---

## Phase 8 — Troubleshooting Reference

### Tunnel shows "No traffic" or "Waiting"

**Cause:** PSK mismatch between the two tunnel endpoints.  
**Fix:** Delete and recreate tunnels on both sides using the same PSK. Always copy-paste the PSK — never retype it.

### Tunnels are Established but BGP shows "Idle" or "Active"

**Cause:** `169.254.x.x` address pairs are not mirrored correctly.  
**Fix:** Verify that for each tunnel, Site A's Cloud Router BGP IP equals Site B's BGP peer IP, and vice versa.

### BGP is Established but no routes appear

**Cause:** Subnets not advertised, or TCP 179 blocked between router peers.  
**Fix:** In Cloud Router settings, confirm **All subnets visible to Cloud Router** is enabled.

### IKE Phase 1 failure

**Cause:** IKE cipher mismatch or UDP 500 blocked by an upstream firewall.  
**Fix:** Confirm IKEv2 is selected on both sides. Check that the HA VPN gateway external IPs are not blocked.

---

## Useful Cloud Shell Commands

```bash
# List all VPN tunnels and their status
gcloud compute vpn-tunnels list

# Describe a specific tunnel
gcloud compute vpn-tunnels describe vpn-tunnel-a-to-b-if0 --region us-central1

# List Cloud Routers
gcloud compute routers list

# Get BGP session status for a router
gcloud compute routers get-status cloud-router-site-a --region us-central1

# List BGP learned routes (JSON)
gcloud compute routers get-status cloud-router-site-a \
  --region us-central1 \
  --format='json(result.bgpPeerStatus)'
```

---

## Reference Documentation

| Resource | URL |
|---|---|
| HA VPN Overview | https://cloud.google.com/network-connectivity/docs/vpn/concepts/ha-vpn |
| HA VPN Between Two GCP Networks | https://cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn |
| Cloud Router Overview | https://cloud.google.com/network-connectivity/docs/router/concepts/overview |
| BGP Configuration Guide | https://cloud.google.com/network-connectivity/docs/router/how-to/configuring-bgp |
| Supported IKE Ciphers | https://cloud.google.com/network-connectivity/docs/vpn/concepts/supported-ike-ciphers |
| VPN Troubleshooting | https://cloud.google.com/network-connectivity/docs/vpn/support/troubleshooting |
| RFC 4301 — IPSec Architecture | https://www.rfc-editor.org/rfc/rfc4301 |
| RFC 4303 — ESP | https://www.rfc-editor.org/rfc/rfc4303 |
| RFC 7296 — IKEv2 | https://www.rfc-editor.org/rfc/rfc7296 |
| RFC 3948 — NAT-T | https://www.rfc-editor.org/rfc/rfc3948 |
| RFC 4271 — BGP-4 | https://www.rfc-editor.org/rfc/rfc4271 |