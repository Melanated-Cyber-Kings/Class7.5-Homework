## Google Cloud Platform – Global Load Balancer Services, ClickOps & Terraform Code
This assignment focuses on foundational GCP infrastructure concepts, including global load balancing, Cloud Armor, and Cloud CDN. It includes ClickOps procedures in the runbook and Terraform code to automate deployment of a Managed Instance Group and related networking components.

### Questions & Answers
#### Load Balancers

How does load balancing contribute to fault tolerance? What about high availability?

Load balancing helps with fault tolerance by routing traffic only to healthy backend resources (such as instance groups or Cloud Storage based backends). If one or more servers become unavailable, the load balancer automatically stops sending traffic to those targets. This prevents users from being directed to failed or unhealthy systems and helps maintain service availability.

Load balancing also supports high availability by distributing traffic across multiple backends, zones, or even regions. If one zone or region becomes unavailable, the load balancer can shift traffic to another location that is still healthy. This keeps the service online even during outages or localized failures.

Do global load balancers decrease latency for end users? Why or why not?

Yes, global load balancers can help reduce latency. They use Google Cloud Platform’s global anycast network, which directs users to the Point of Presence (POP) closest to them. Once the request enters the nearest POP, Google routes it internally to the closest healthy backend. This avoids long distance public internet routes and improves performance for the end user.

What are LB health checks for? Do we always need them? Is an LB different from a reverse proxy?

Health checks verify that backend servers are responsive and functioning correctly. If a backend fails a health check, the load balancer automatically stops sending traffic to it. In production environments, health checks are essential because they prevent users from being routed to servers that are down, misconfigured, or overloaded. A load balancer (LB) is technically a type of reverse proxy, but it provides additional capabilities.

#### Reverse Proxy
A reverse proxy sits between clients (such as browsers or applications) and backend servers. It forwards incoming requests to a backend server and then returns the server’s response to the client. Its main job is to act as an intermediary.

#### Load Balancer
A load balancer performs the same reverse proxy function, but its primary purpose is to distribute traffic across multiple backend servers. In addition, it provides features such as:

- Health checks to ensure only healthy servers receive traffic
- Global routing based on criteria like geographic location or latency
- Failover across zones or regions

What are LB routing rules and URL maps for? Give examples.

Routing rules and URL maps tell the load balancer how to direct traffic based on details in the incoming request, such as the URL path or hostname. They allow you to control exactly which backend service receives which type of traffic. A URL map is a set of rules the load balancer follows to decide where to send a request.

**Examples**
- https://webstore.example.com/video routes to a backend service that handles video content

- https://webstore.example.com/graphics routes to a Cloud Storage backend bucket for static graphics

- https://webstore.example.com/ routes to a default backend service such as the main web application or index.html

Where URL Maps Are Used:
    - External Application Load Balancers
    - Internal Application Load Balancers
    - Cloud Service Mesh

Explain what an anycast IP address is used for in the context of a global load balancer.

A global external load balancer uses a single global anycast virtual IP (VIP) address. This IP address is advertised from Google’s Points of Presence (POPs) around the world. When a user connects to the service, their request is automatically routed to the nearest POP based on network distance. From that POP, Google’s internal network forwards the request to the closest healthy backend that is hosting the application or service.

#### Cloud Armor
What does Cloud Armor offer?

Cloud Armor is Google Cloud’s Web Application Firewall (WAF). It filters and monitors HTTP and HTTPS traffic between applications and the internet. It is designed to protect web applications from common internet‑based threats.

Why is it used in the first place?

Cloud Armor is used to protect publicly accessible applications from malicious traffic such as SQL injection, cross‑site scripting (XSS), and denial‑of‑service attempts.

What layer in the OSI model does it operate at? Why is this important and how is this firewall different from VPC firewall rules?

Cloud Armor operates mainly at Layer 7 (Application Layer), allowing it to inspect HTTP and HTTPS traffic in detail, including headers, payloads, URLs, and request patterns. It also provides protection at Layer 3 and Layer 4 at the network edge.

Differences from VPC firewall rules
- VPC firewalls operate only at Layer 3 and Layer 4

- Cloud Armor operates at Layer 7

- VPC firewalls filter IP, port, and protocol

- Cloud Armor protects against SQL injection, XSS, bot attacks, and application‑layer DDoS

What are rate based rules for?

Rate based rules limit how many requests a client can send within a specific time period. They help protect applications from excessive traffic that could cause an outage or denial of service.

What is reCAPTCHA and how does it relate to this service?
reCAPTCHA is Google Cloud’s fraud defense service that helps determine whether an incoming request is from a human or an automated bot. Cloud Armor integrates with reCAPTCHA to challenge suspicious traffic and block requests that fail the challenge.

#### Cloud CDN
What are POPs used for?
Points of Presence (POPs) are Google’s edge locations where cache servers store previously requested content.

What kind of files are served with Cloud CDN?
Cloud CDN is ideal for static or cacheable content, such as:

- Images
- Videos
- CSS and JavaScript
- Static website content
- Software downloads
- Large media files

What services can be used with Cloud CDN for the source of content (the origin)?
Global External Application (HTTP/HTTPS) Load Balancer

Classic Application Load Balancer

Cloud Storage buckets

Backend services such as VMs, instance groups, and NEGs

Does Cloud CDN help protect against any types of malicious actors or cyberattacks? Explain.
Cloud CDN is not a dedicated security product, but it helps reduce the attack surface by:

- Absorbing large traffic spikes
- Serving cached content at the edge
- Working with Cloud Armor to block malicious requests

Should an enterprise always use Cloud CDN? Why or why not?
Cloud CDN is beneficial when:

- You serve static or cacheable content
- You have global users
- You want lower latency and reduced backend load

Cloud CDN may not be appropriate when:

- Content is highly dynamic
- Responses change per user
- Real‑time data is required
- You provide large downloads or streaming media

What is TTL and how does it control content “freshness”?
TTL (Time to Live) defines how long content stays cached before the CDN checks the source server for updates.

- Short TTL → fresher content
- Long TTL → better performance and fewer origin requests

### RUNBOOK
#The runbook section is a work in progress in file named RUNBOOK.md. The final version will be included in the final submission of this assignment.

#### Terraform Code for Managed Instance Group Creation
#Terraform code is under development under folder named terraform. The final version will be included in the final submission of this assignment.