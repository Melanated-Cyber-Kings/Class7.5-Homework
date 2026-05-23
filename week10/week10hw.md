# Q&A
<br/>
<br/>

## DNS & SSL/TLS
<br/>
<br/>

1) Explain what the traceroute and dig commands do. Compare and contrast.
<br/>

Answer: The traceroute command maps the route where a packet takes from your computer to the destination server/PC. It identifies each hop it takes to get to that destination. The dig command questions the DNS (domain name system) for certain records associated with it, see how TTL value, trace the IP addresses and much more. 
<br/>

2) What are the 3 or 4 most common DNS records and what are their use cases?
<br/>

Answer: A name records (maps a domain name to an IPv4 address), AAAA name records(maps a domain name to a IPv6 address), and CNAME records (points a domain to a subdomain or another domain rather than an IP address). 
<br/>

3) Give an overview of the steps in a TLS handshake. 
<br/>

Answer: The client's browser sends a "ClientHello" to a server, the server responds back with a "ServerHello", the Server presents its Digital Certificate to the client's browser, the client's browser validates the server's certificate and sends an encrypted premaster secret to the Server, and the Server decrypts the premaster secret and computes the session key, and then you have a secured connection estabished between a client's browser an a server. 
<br/>

4) How does an SSL/TLS cert know what domain it belongs to?
<br/>

Answer: A SSL or TLS certificate knows which domain it belongs to because it's hardcoded into the certificate's data fields during the TLS handshake with the domain name service. 
<br/>

5) What is a certificate authority?
<br/>

Answer: A certificate authority is an outside party or organizatino that confirms that the website owner is who they say they really are. They also, keep a copy of the certificates they issue.
<br/>
<br/>

## Load Balancers
<br/>
<br/>

1) How do application load balancers in GCP offload (decrypt) SSL? What part of the load balancer does this?
<br/>

Answer:
<br/>

2) Are there use cases to have in flight encryption from the backend service to the backend itself?
<br/>

Answer:
<br/>
<br/>

## Cloud Domain/DNS
<br/>
<br/>

1) Can multiple domains end up pointing to the same Load Balancer?
<br/>

Answer:
<br/>

2) In the context of Cloud DNS, what are zones?
<br/>

Answer:
<br/>
<br/>

# Runbook
<br/>
<br/>

