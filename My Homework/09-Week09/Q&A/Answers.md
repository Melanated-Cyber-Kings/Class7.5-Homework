## Load Balancers
*How does load balancing contribute to Fault tolerance? What about high availability?*

LB contribute to fault tolerence by redirecting traffic towards healtthy services when incidents happen.
LB help with HA by minimizing downtime

*Do global load balancers decrease latency for end users? Why or why not?* 

GLB minimizes latency and optimizes response times, ensuring that users connect to the nearest or least congested server.

*What are LB health checks for? Do we always need them? Is a LB different from a reverse proxy?*
LB health checks enable autohealing.
We don't always need them but it is better to use them to manage services.
They serve the same function but LBs are used in multi server environments while RVP are used even in single server environments.

*What are LB routing rules and URL maps for? Give an example or two of them in use.* 

In load balancing, routing is the process of distributing incoming client requests to a pool of available servers. There are a variety of routing mechanisms available depending on what a specific application or use case requires.

A URL map is a list of URLs or shell-style match expressions that define a URL set
any map worth using can be broken down into five basic elements:
- Title.
- Scale.
- Legend.
- Compass.
- Latitude and Longitude.

*Explain what an anycast IP address is used for in the context of a global load balancer.*
Multiple servers sharing the same IP address, with the network automatically routing traffic to the closest possible one

## Cloud Armor
*What does cloud armor offer?* 
Cloud Armor provides always-on protection from Layer 3 and 7 protocol-based DDoS attacks, with automated inline mitigations in real time and with no latency impact.

*Why is it used in the first place?*
CLOUD ARMOR is a security framework built into the Google Cloud Platform, which protects hostile traffic before it reaches the designated cloud target.

*What layer in the OSI model does it operate at? Why is this important and how is this firewall different from VPC firewall rules?*
It operates at layer 7. Cloud armor WAF is for LB while VPC firewall is for the VPC.

*What are rate based rules for?*
Rate-based rules help you protect your applications from a large volume of requests that flood your instances and block access for legitimate users.

*What is reCAPTCHA and how does it relate to this service?*
reCAPTCHA is a powerful bot blocker that protects websites from spam, abuse, and fraud. It works by analyzing user behavior and other factors to determine if an action is being performed by a human or a bot.
You can integrate it on cloud Armor.

## Cloud CDN 
*What are POPs used for?*
CDN PoPs (Points of Presence) are strategically located data centers responsible for communicating with users in their geographic vicinity.

*What kind of files are served with Cloud CDN?*
A CDN allows for the quick transfer of assets needed for loading Internet content, including HTML pages, JavaScript files, stylesheets, images, and videos.

*What services can be used with cloud CDN for the source of content (the origin)?*
As origins, you can use:

- Bucket from Yandex Object Storage, for example, configured as a static site hosting.
- L7 network load balancer from Yandex Application Load Balancer. CDN servers will access the load balancer at one of its IP addresses that must be selected in the origin settings.
- Your own server or another resource available by domain name. For example, if the origin is a server with the files.example.com domain name, to get the /static/common.css file, CDN servers will try access the server at this address: files.example.com/static/common.css

*Does Cloud CDN help protect against any types of malicious actors or cyberattacks? Explain.*
CDNs can improve website security by providing DDoS mitigation, managing security certificates, hosting a WAF, and other optimizations. 
Because it sits at the edge of the network, it can identify and block many types of malicious traffic before they reach the origin server.

*Should an enterprise always use cloud CDN? Why or why not?*
You should use it, if you have a large sized web application and you want uninterrupted service to users.
For small localized web applications a CDN may not be useful.

*What is TTL and how does it control content “freshness”?*
Time to live (TTL) is how long content or a query is retained in DNS and CDN caching.