# Q&A

## How does load balancing contribute to Fault tolerance? What about high availability?
- Fault tolerance is the ability of a system to have a failure and be able to continue running. Load balancing contributes to this in that when a server is seen as unhealthy a load balancer will stop sending traffic to it. Those accessing the server on the front end wont notice because traffic will just flow to a server that works. 
- High availability refers to a system that gets as close at it can to being available 100% of the time. Load balancing helps with this as it keeps a service from going down due to rerouting traffic when a server becomes unavailable. This keeps a service from experiencing downtime. It also helps alleviate having a single point of failure in your infrastructure.

## Do global load balancers decrease latency for end users? Why or why not?
- Yes global load balancers decrease latency by making sure they route user requests to the nearest server possible, thus decreasing latency time for the end users.

## What are LB health checks for? Do we always need them? Is a LB different from a reverse proxy? 
- Load Balancer health checks are used to do time-intervaled checks of your servers to make sure that they are still healthy.
- We dont always need them but they are mandatory for GCP load balancing to keep up with backend health.
- Load balancers and reverse proxies are different but kind of do the same things. They both help with the distribution of traffic requests but a reverse proxy focuses on a single web application while a load balancer is focused on a fleet of servers.

## What are LB routing rules and URL maps for? Give an example or two of them in use.
- Lb routing rules dictate how LB's distribute traffic to their backend services. URL maps dictate how http traffic is routed to your backend services. 

## Explain what an anycast IP address is used for in the context of a global load balancer. 
- an anycast IP address is an ip address that is assigned to multiple servers across the load balancer, so all requests hit the same IP address but the traffic is routed to different servers across the world. This reduces traffic by making the routes shorter.

## What does cloud armor offer? 
- Cloud armor offers protection from DDos attacks. It filters access to your HTTPS load balancer.

## Why is it used in the first place?
- Cloud armor is used to filter access to your HTTPS load balancers. It uses Google's global network and distributed infrastructure to "detect and absorb attacks and filter traffic through user-configurable security policies at the edge of Google's network, far upstream of your workloads."
- http://docs.cloud.google.com/armor/docs

## What layer in the OSI model does it operate at? Why is this important and how is this firewall different from VPC firewall rules? 
- Google Armor protects your infrastructure applications at layers 3 (network), 4 (transport), and 7 (application layer). It is more focused on the traffic that is hitting your infrastructure at the edge as a whole where as VPC firewall rules focus on one VPC at a time. 

## What are rate based rules for? 
- Rate based rules are used in GCP to protect applications from traffic spikes by limiting the number of requests and the rate at which those requests are allowed within a specific time.

## What is reCAPTCHA and how does it relate to this service? 
- reCAPTCHA is a security service that is provided by google that watches actions on a webpage to see if a user is a real human or a malicious bot before allowing them to access a service. It is a complimentary service to Cloudarmor that helps with comprehensive bot management.
- https://docs.cloud.google.com/armor/docs/bot-management

## What are POPs used for?
- POP's are just facilities where google's network connects to other networks. They are edge locations that allow google to exchange traffic directly with local services to provide a better experience.

## What kind of files are served with Cloud CDN??
- Cloud CDN is used for serving a mix of static and dynamic latency-sensitive web assets, such as CSS, JavaScript, HTML, and image files.

## What services can be used with cloud CDN for the source of content (the origin)? 
- Cloud CDN can use:
1. Cloud Storage Buckets
2. Virtual Machine instances
3. GKE container instances
4. Custom Origins
5. App Engine, Cloud Run Functions, or Cloud Run services

## Does Cloud CDN help protect against any types of malicious actors or cyberattacks? Explain.
- CDN's provide security by terminating SSL/TLS connections closer to users, offering DDos protections, deploying WAFs and managing SSL certificates.
- Data is encrypted at rest and in transit from Cloud Load Balancing to the backend for end-to-end encryption
- You can programmatically sign URLs and cookies to limit access to authorized users only. The signature is validated at the CDN edge and unauthorized requests are blocked there.
- https://cloud.google.com/blog/topics/developers-practitioners/what-cloud-cdn-and-how-does-it-work
- https://www.cloudflare.com/learning/cdn/cdn-ssl-tls-security/

## Should an enterprise always use cloud CDN? Why or why not?
- Cloud CDN servers come with their own pro's and con's
- They cache data in replica sercers which allow for faster load times and lower bandwidth usage thus contributing to better website performance.
- CDNs have many possible uses and offer many digital solutions for different industries.
- Setting up a CDN and operating it requires more effort because the data is no longer on a single server
- Having data on replica servers protect the origin from attacks but create more gateways for hackers. 
- https://cloudplex.megazone.com/en/resources/01
- https://www.cloudflare.com/learning/cdn/cdn-benefits/
- https://www.asioso.com/en/blog/advantages-and-disadvantages-of-a-content-delivery-network-b516

## What is TTL and how does it control content “freshness”? 
- TTL is the amount of time an object will remain cached. Once the TTL is met or exceeded, the object becomes *stale*, which means there likely is a fresher version of the object available.
- https://www.fastly.com/learning/cdn/what-is-time-to-live-ttl

# Runbook

## Goal
- To have a fully configured load balancer with a managed instance group as a backend. This walkthrough will take you step by step through the creation of the managed instance group and the laod balancer in the GCP Console. 

### Prerequisites
1. A GCP account
2. An Instance Template
3. A bucket

## Steps

### Create your managed instance group
- Go to the Google Console
- Go to the instance group page
- Create Instance Group
- name your instance group and give it a description
- select your instance template
- select your desired number of instances
- select your region and zones
- select your health check
- Create your instance group

### Create the Load Balancer
- Go to the load balancer main page in the GCP console
- Select create a Load Balancer
- Select type - Application Load Balancer
- Select type - Public Facing (so that the internet can reach our load balancer)
- Select Global Deployment
- Load Balancer Generation - Global external Application Load Balancer
- Create the Load Balancer
- Give your LB a name

### Frontend Configuration
- name your frontend and give it a description
- make sure protocol is set to HTTP
- IP version - IPv4
- IP address - Ephemeral
- Port - 80
- HTTP Keepalive timeout - 30 seconds
- Done

### Backend Configuration
- **Create a Backend Service**
- name your backend and give it a description
- Backend type - Instance Group
- Protocol - HTTP
- Named port - http
- Timeout - 30
- IP address selection policy - Only IPv4
- Create your Health Check
- name your health check and give it a description
- Protocol - TCP Port - 80
- turn logs to ON
- Check Interval - 10 seconds
- Timout - 5 seconds
- Create your health check
- Instance group - select the instance group you made earlier
- Port numbers - 80
- Cloud Armor - default-security-policy
- Create
- **Create a Backend Bucket**
- name your backend bucket and give it a description
- select a bucket you have created
- Create

### Routing Rules
- delete the routing rules that are pointed toward the bucket

**Create your load balancer**




