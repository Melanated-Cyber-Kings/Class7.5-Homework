# Week 9 Q&A


## Load Balancers (LB)

#### **How does load balancing contribute to Fault tolerance? What about high availability?** 
Fault tolerance is the ability to keep the system running when something breaks. Load Balancers (LB) do this through health checks. LB constantly ping the servers to see if they respond. Example - Server B stops working. The LB realises that Server B isn't responding and stops sending traffic to it and reroutes everyone to the other available servers. This results in users never noticing that a server died. That's how LB contribute to fault tolerance.
High Availability is about uptime, making sure the app is reachable, measured by 99.XXX%. LB help with high availability by spreading the weight of incoming traffic across a many different servers. This takes away 'single point of failure'. Example - Instead of one big server doing everything, we have four smaller ones. If the app get a traffic spike, the LB shares the traffic across all of the servers so none of them are overwhelmed.

#### **What are LB health checks for?**
A LB health check is constantly checking the servers to see if they are still awake. Without health checks, the LB will keep sending traffic to a server that has crashed, or is running out of memory. This leads to the users experiencing errors. Health checks make sure LB only send traffic to healthy servers.
**Do we always need them?**
In a professional environment, Yes. If you don't have health checks, you don't have high availability.
The exception is if you don't care if the app goes down for a while or you wan to manually fix it. Example - a lab.

#### **Is a LB different from a reverse proxy?**
Depends. I found this quite confusing. What helped me understand was to break down what the load balancers do at Layer 4 and Layer 7.
Layer 4 LB - lightweight, very low latency and is ideal for simple TCP/UDP traffic (IP address and port) without reading content.
Layer 7 LB - more features and intelligent but requires more processing power. Ideal for web traffic, microservices and API gateways. At Layer 7, a load balancer accepts the client’s connection and then creates a new connection to the backend server, which is exactly how a reverse proxy works.

LB primary focus is on high availability and scalability across multiple servers.
#reverseproxy
Reverse Proxy (RP) is a broader category, primary focus is on security, performance. It can act as a gateway and load balancer also.

This lead me to ask another question. 
###### **In what situations would you use a reverse proxy and not a L7 load balancer?**
There are times when we want reverse proxy features without traffic distribution. Examples - 
1 - Single backend server. A simple reverse proxy is far lighter than making a load balancer for one connection.
2- SSL/TLS termination only
3 - Caching layer. RP have caching features to reduce load.
4 - Authentication & Access control. The proxy can enforce auth before handing off to the next stage.

What makes them different is the emphasis.
When you emphasize distributing load across a servers, you call it a Load Balancer.
When you emphasize security, caching, and protecting your backend, you call it a Reverse Proxy.

https://www.f5.com/glossary/reverse-proxy-vs-load-balancer
https://www.loadbalancer.org/blog/what-exactly-is-a-reverse-proxy/
https://www.upguard.com/blog/reverse-proxy-vs-load-balancer

#### **Do global load balancers decrease latency for end users? Why or why not?** 
#### **Explain what an anycast IP address is used for in the context of a global load balancer.**

Yes they can. Basically, the shorter the distance, the lower the latency.
The idea is geographic routing. Instead of all users hitting one data center, a global load balancer directs each user to the nearest one. A user in Tokyo get routed to Singapore, not New York. The shorter the distance means fewer network hops and lower trip time, which reduces latency.

Two main methods are DNS-based routing, Global Server Load Balancing (GSLB) and **Anycast**.

GSLB  - When you type in a website address, DNS first checks where that website lives. DNS-based routing helps direct you to the best available server. It looks at things like which server is healthiest, fastest, and closest to your location, then sends you there. helping This helps websites load faster and stay available even if one location has problems.

Anycast - is a way of making the same online service available from multiple locations around the world using one shared IP address. When someone connects, the internet usually sends them to the location it believes is closest. Anycast works really well for things like website content because it’s fast and happens automatically behind the scenes. The downside is you have less control. Being the closest server doesn’t always mean it’s the fastest or healthiest location. And if one location has a problem, it can take a little time for internet traffic to automatically find and switch to another one.


https://www.splunk.com/en_us/blog/learn/global-server-load-balancing-gslb.html
https://sre.google/workbook/managing-load/
https://www.dyncond.com/geo-dns-anycast-and-gslb-whats-the-best-approach-for-global-performance/

#### **What are LB routing rules and URL maps for? Give an example or two of them in use.** 

Routing Rules and URL Maps are like the brain of the load balancer. These are used for Layer 7 LB. They allow you to use one single IP address to lead to different servers based on what is being asked for.

A URL map is a routing table for HTTP(S) traffic. It inspects incoming traffic and decides where to send them based on things like the URL path, hostname, headers etc.

Example 1 - Path Based
Say you have a website like `biglizzo.com`. You don't want your 'Account Settings' servers to be the same ones that handle 'Video Streaming' as they have different jobs.
If the URL path starts with `/video`, send the user to the video servers.
If the URL path starts with `/account`, send the user to the database servers.
The rest go to web servers.
This is done so we can scale our servers separately.

Example 2 - Host-Based
Say you have a online bookstore, `morebooks.com`. The developer team is always working on new features.
You want live website that customers use, but you also have a 'test' version where you try new features before gong live.
Instead of buying separate load balancers for both, you use Host-based routing to separate them by subdomains for simplicity.
If the host is `app.morebooks.com`, route traffic to the production servers (the stable live version).
If the host is `dev.morebooks.com`, route traffic to the staging servers (the testing version).
This is cost efficient as you pay for one load balancer and one public IP address but you manage three different environments.
Different security rules can be applied. Example only allow `dev.morebooks.com` to be accessed from your office's IP.


https://docs.cloud.google.com/load-balancing/docs/url-map-concepts
https://docs.cloud.google.com/load-balancing/docs/url-map
https://www.alibabacloud.com/help/en/slb/classic-load-balancer/use-cases/forward-requests-from-the-same-domain-name-but-different-urls



## Cloud Armor

#### What does Cloud Armor offer? Why is it used in the first place?
Cloud Armour tackles two main jobs. Stopping DDoS attacks and acting as a Web Application Firewall.
DDoS Protection - It protects against network-level (Layer 3/4) attacks and application-layer (Layer 7) attacks.
Web Application Firewall (WAF) - Inspects incoming traffic based on OWASP Top 10 (standard of critical web application security risks)

https://docs.cloud.google.com/armor/docs/cloud-armor-overview
#### Why is it used in the first place?
First line of defence. It blocks bad traffic before it enters your network.
It's integrated into Google Cloud which makes it easy to manage security with GCP resources.

#### What layer in the OSI model does it operate at? Why is this important and how is this firewall different from VPC firewall rules? 
Cloud Armour operates at multiple layers.
If you understanding the layers it operates at help you understand what threats it can stop.
Deep inspection at Layer 7. DDoS prevention at Layer 3/4.

Clous Armour operates at the network edge. It filters traffic before it enters your VPC.
VPC Firewalls Rules operate inside the VPC network. Deals with traffic as it comes in & out from specific VMs.

#### What are rate based rules for? 
Rate based rules are about setting limits for incoming requests. Rate based rules look at how many requests are coming from a single client over a short period.
Example - You can make a rule saying, "If the same IP address sends more than 500 requests in 5 minutes, block them for the next 10 minutes"

https://docs.cloud.google.com/armor/docs/rate-limiting-overview
#### What is reCAPTCHA and how does it relate to this service? 
reCAPTCHA is a smart tool that uses advanced techniques to figure out if a user is a real human or a bot.
ReCAPTCHA is not a standalone product; but a plugin that works directly into your Web Application Firewall (WAF) - Cloud Armour. In Google's case, it natively plugs right into Cloud Armor. This integration creates a feature called **Bot Management**.

https://docs.cloud.google.com/recaptcha/docs/waf-overview
https://docs.cloud.google.com/armor/docs/bot-management
https://cloud.google.com/blog/products/identity-security/announcing-new-cloud-armor-rate-limiting-adaptive-protection-and-bot-defense



## Cloud CDN 

#### What are POPs used for? 
Cloud CDN caches copies of websites content on a globally distributed network of servers. This puts the content closer to your users for faster delivery.
Points of Presence (POPs) are the physical data centres spread across the world. This is where the cached content is stored.
When a user makes a request, they are sent to the nearest POP and receive a cached copy. 
Cloud CDN are located in more than 100 locations.

https://docs.cloud.google.com/cdn/docs/overview?hl=en
https://docs.cloud.google.com/cdn/docs/locations
#### What kind of files are served with Cloud CDN? 
Cloud CDN is made for static content. This remains the same for every user.
This includes images, video, documents etc.
Dynamic content is not typically cached.

https://docs.cloud.google.com/cdn/docs/caching#static
#### What services can be used with cloud CDN for the source of content (the origin)? 
The origin is where you content lives before it is cached.
Cloud CDN supports a range of backends from Cloud Storage Buckets to compute origins (Compute Engine, GKE, App Engine). Also Application Load Balancer.
https://docs.cloud.google.com/cdn/docs/quickstart-backend-bucket-console?hl=en
https://docs.cloud.google.com/cdn/docs/overview?hl=en

#### Does Cloud CDN help protect against any types of malicious actors or cyberattacks? Explain. 
Cloud CDN provides protection against DDoS attacks.
It does this by taking the malicious traffic before it reaches your origin rescources.
https://cloud.google.com/blog/products/identity-security/how-to-protect-your-site-from-ddos-attacks-with-cloud-networking/
#### Should an enterprise always use cloud CDN? Why or why not? 
Yes - When you have globally distributed users. If you have a lot of static content. also to reduce cost on data egress by caching data that is requested often.
No - When your users are regional. Your content is dynamic or user specific.

#### What is TTL and how does it control content “freshness”?
Time to Live (TTL) is a timer that tells the CDN how long to keep a file in its cache before checking for a fresh copy.
When a user asks for a file, if the TTL has not expired, the file is served instantly.
If the TTL is over the limit, the CDN will get the latest version from the origin, cache it again, and give that fresh content to the user.
Cloud CDN odders 3 cache modes:
`CACHE_ALL_STATIC` - manages TTL for static content automatically
`USE_ORIGIN_HEADERS` - uses your origin's cache headers
`FORCE_CACHE_ALL` - allows you to override everything
https://docs.cloud.google.com/cdn/docs/using-ttl-overrides?hl=en