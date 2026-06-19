# Week14 Individual Work
## Explain the differences and similarities between HA VPN and NCC
- HA VPN and NCC are both used as ways of delivering traffic in GCP. 
- Both incorporate Cloud Routers and BGP protocols to maintain traffic routes. HA VPN's using them to establish direct peer relationships and NCC using the HA VPN's as spokes, to manage them.
- Both offer high-uptime SLA's
- The main difference is that HA VPN's are used for one to one connections while NCC is more of a hub and spoke model.
- HA VPN's are a regional product while NCC is global

## Explain the use cases of HA VPN vs NCC. 
- HA VPN is used when you want a single point to point connection
- NCC is used when you want to connect together a full large-scale network and you want to centralize the maintenance of it. 
## Explain the use cases of the Network Intelligence Center. 
- The Network Intelligence Center is a console that gives you full network visibility over your project. 
- It allows you to monitor real-time metrics in a single console-
- It can be used to diagnose connectivity issues and prevent outages
- It can be used to verify network security and compliance to help tighen your security boundaries. 