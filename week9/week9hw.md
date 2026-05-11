# Q&A

## LOAD BALANCERS

1) How does load balancing contribute to Fault tolerance? Load balancers increase the fault tolerance of your systems by automatically detecting server problems and redirecting client traffic to available servers.
<br/>

2) What about high availability? Load balancers contribute to high availability by acting as a traffic director that distributes incoming requests across multiple backend servers, eliminating single points of failure.
<br/>

3) Do global load balancers decrease latency for end users? Yes, load balancers acheive this by directing traffic to the least congested servers or to the servers closest to users, Global Load Balancers enables faster and more reliable response times for better user experiences.
<br/>

4) What are LB health checks for? Load Balancer health checks are critical for ensuring high availability by continuously monitoring backend servers' status and automatically routing traffic only to functional, responsive instances. They prevent user requests from being sent to overloaded, failed, or malfunctioning servers, thereby preventing downtime.
<br/>

5) Do we always need them? We should always need health checks for servers, because users need a fast and reliable way to access our servers.
<br/>

6) Is a LB different from a reverse proxy? Yes, a load balancer primarily focuses on distributing traffic across multiple backend servers to ensure high availability and scalability. A reverse proxy acts as an intermediary for web requests to improve security, performance (via caching), and manage traffic.
<br/>

7) What are LB routing rules and URL maps for? Load Balancers routing rules and URL maps are for directing incoming client requests to specific backend services or buckets based on the URL host, path, headers, or query parameters.
<br/>

    Load Balancing Routing Rules example:
<br/>

    URL Maps example:
<br/>

8) What is an anycast IP address used for in the context of a Global Load Balancer? An anycast IP address routes user traffic to the nearest or most efficient server, reducing latency (faster load times), improving service availability, and strengthening resilience against DDoS attacks.
<br/>

## Cloud Armor
<br/>

1) What does cloud armor offer? Google Cloud Armor provides security for your applications and services, by combining robust DDoS mitigation with a Web Application Firewall (WAF). It protects against Layer 3/4 volumetric DDoS attacks and Layer 7 threats by utilizing Google's global load balancing infrastructure to block malicious traffic at the edge of the network.
<br/>

2) Why is Cloud Armor used in the first place? Because Cloud Armor is a Web Application Firewall and it understands HTTP and inspects web requests for application-layer attacks.
<br/>

3) What layer in the OSI model does it operate at? It operates at Layers 3 and 4 (Network), and Layer 7 (Application) layers.
<br/>

4) Why is this important and how is Cloud Armor Firewall different from VPC firewall rules? Cloud Armor works at the Google Edge before traffic reaches your network, mitigating attacks before they impact infrastructure. Firewall rule ports act on incoming (ingress) or outgoing (egress) packets at the VPC level.
<br/>

5) What are rate based rules for? Rate based rules are for tracking the number of requests from a specific source (like an IP address) within a set time, like 5 or 10 minutes.
<br/>

6) What is reCAPTCHA and how does it relate to this Cloud Armor? reCAPTCHA is a free service that protects your site from spam and abuse. It uses advanced risk analysis techniques to tell humans and bots apart. Google Cloud Armor integrates with reCAPTCHA Enterprise to provide advanced bot detection and management at the edge of the network. By validating reCAPTCHA action-tokens, Cloud Armor allows you to block, throttle, or challenge suspicious traffic at the HTTP(S) load balancer before it hits backend services, enhancing security and reducing origin load.
<br/>
<br/>

## Cloud CDN
<br/>

1) What are POPs used for? POPS are locations across the globe that deliver content from the edge closest to users, significantly reducing latency and lowering bandwidth costs.
<br/>

2) What services can be used with cloud CDN for the source of content? Google Cloud Storage buckets for static content, Compute Engine instances, and Google Kubernetes Engine (GKE) clusters. It also supports serverless options like Cloud Run and App Engine.
<br/>

3) Does Cloud CDN help protect against any types of malicious actors or cyberattacks? Yes, it acts as a shield for origin servers, specifically mitigating volumetric DDoS attacks, managing bot traffic, and integrating with web application firewalls (WAF) to secure content.
<br/>

4) Should an enterprise always use cloud CDN? Yes, they should use Cloud CDN to enhance website performance, security, and scalability. By caching content on global edge servers, CDNs reduce latency, boost SEO, and lower origin server costs. They are ideal for high-traffic, media-rich sites, or global audiences, offering essential security against DDoS attacks.
<br/>

5) What is TTL and how does it control content "freshness"? Time to Live (TTL) is a numerical value set in networking packets or DNS records that acts as an expiration date, determining how long data should exist, be cached, or travel before being discarded. It controls content by preventing data loops in networks and dictating how frequently DNS records or web content (like images/pages) are refreshed in a user’s cache.
<br/>
<br/>

## Runbook
