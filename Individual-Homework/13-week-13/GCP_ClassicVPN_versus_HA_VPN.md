
## Google Cloud - Classic VPN vs. HA VPN

### Classic VPN
A single‑interface, single‑tunnel IPSec VPN with:

One external IP

One VPN gateway interface

One or more tunnels, all tied to the same interface

Static routing only

No BGP

No redundancy

Manual route updates

Analogy: 
Classic VPN = one encrypted circuit from NYC → NJ.

```
On‑prem  (IPSec Tunnel)  Classic VPN Gateway  VPC
```


### HA VPN
A dual‑interface, dual‑tunnel VPN with:

Two external IPs (interface 0 and interface 1)

Each interface supports one tunnel

Redundant across zones

Supports active‑active or active‑passive

Uses Cloud Router + BGP

Dynamic route exchange

Automatic failover

Supports ECMP

Production‑grade

Analogy: 
HA VPN = two encrypted circuits to the same destination, each taking a different physical path:

NYC → Philadelphia → NJ

NYC → Virginia → NJ

If one path fails, traffic is routed via the alternate network route.

```
Tunnel A1                Tunnel B1
On‑prem                  HA VPN Gateway (Interface 0)

Tunnel A2                Tunnel B2
On‑prem                  HA VPN Gateway (Interface 1)
```

## When are they used?

Classic VPN
Legacy deployments

Simple test environments

Non‑critical workloads

HA VPN
Production workloads

High‑availability hybrid connectivity

Multi‑region or multi‑site networks

### References

- https://cloud.google.com/network-connectivity/docs/vpn/concepts/overview

- https://cloud.google.com/network-connectivity/docs/vpn/concepts/topologies

- https://cloud.google.com/network-connectivity/docs/vpn/concepts/classic-topologies

- https://cloud.google.com/network-connectivity/docs/vpn