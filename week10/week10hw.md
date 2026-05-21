# Q&A 

## DNS and SSL/TLS

1) Explain what the traceroute and dig commands do. Compare and contrast.

Answer: The traceroute command shows you what routes data packets take from your computer to each router to get to their destination such as a server. The dig command provides us information about DNS records for a website, such as AAAA, A, CNAME, MX, and NS recoeds. 

2) What are the 3 or 4 most common DNS records and what are their use cases? 

Answer: The three most commonly used DNS records are A, AAAA, and CNAME records. The use case for an A record is that it changes a domain name to an IPv4 address in a DNS record. The use case for an AAAA record is that it changes a domain name to an IPv6 address in a DNS record. The use case for a CNAME record is that it changes a domain or subdomain to another domain name. 

3) Give an overview of the steps in a TLS handshake.

Answer: A browser establishes a TCP connection, what TLS version can it support?, 

4) How does an SSL/TLS cert know what domain it belongs to?

5) What is a certificate authority?


## Load Balancers

1) How do application load balancers in GCP offload (decrypt) SSL? What part of the load balancer does this?

2) Are there use cases to have in flight encryption from the backend service to the backend itself?

## Cloud Domain/Domain Name Service

1) Can multiple domains end up pointing to the same load balancer?

2) In the context of Cloud DNS, what are zones?
<br/>
<br/>


# Runbook

