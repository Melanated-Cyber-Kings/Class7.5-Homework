Differences & Similarities Between HA VPN and NCC

Connectivity:
- HA VPN connects two endpoints (any cloud service provide/on‑premise).
- NCC connects many endpoints into a unified routing domain (Hub & Spoke)

Routing:
- HA VPN uses BGP between two peers.
- NCC automatically distributes routes across all spokes.

Topology:
- HA VPN = point‑to‑point.
- NCC = hub‑and‑spoke with full‑mesh routing.

Similarities

- Hybrid and multi‑cloud support - Both can connect on‑premise and other cloud service providers.

- Cloud Router integration - Both use BGP for dynamic routing.

- High availability - Both support 99.99% SLA when configured redundantly.

Use Cases: HA VPN vs NCC

When to Use HA VPN

- Multi‑cloud IPsec connectivity - AWS ↔ GCP, Azure ↔ GCP, OCI ↔ GCP.

- GCP‑to‑GCP VPN - When VPC Network Peering is not allowed or you need encryption.

- Encrypted traffic requirement - Mandatory encryption of data-in-transit.

- Rapid deployment - Quick, standards‑based configuration and rollout using NCC VPN wizard, API or CLI.

When to Use NCC

- Global Wide Area Network (WAN) architecture - Connect multiple sites, clouds, and VPCs.

- Full‑mesh routing - Automatic route propagation between all spokes.

- Centralized inspection - Shared firewall VPC or egress VPC.

- Hybrid + multi‑cloud at scale - NCC router appliance spokes integrate SD‑WAN, multi‑cloud routers, etc.

Flexible Cloud Connectivity:
- HA VPN acts as an NCC spoke - HA VPN tunnels attach to NCC hubs.

- Unified traffic management - NCC distributes HA VPN routes to all other spokes.


Network Intelligence Center (NIC):
NIC provides a single‑pane‑of‑glass operational view of your entire network. It supports monitoring, testing, troubleshooting, and health analysis for all interconnections between GCP resources and external environment

When to use the Network Intelligence Center

- Single‑pane‑of‑glass visibility: Observe overall network and gain insight as to networks stability. Helps to support network management and change management planning.

- Topology mapping: near real-time mapping of VPC, VPN, NCC hubs and infrastructure. Helps to evaluate network design and implementation.

- Connectivity troubleshooting: diagnose connectivity issues and network outage prevention.

- Performance monitoring: monitor real-time performance metrics and outages/performance issues. Observe network performance issues like latency, throughput, data collisions, intermittent disconnections.

- Firewall and security posture analysis: perform security posture analysis and firewall rule evaluation. Helps to identify misconfigurations and potential vulnerabilities.





