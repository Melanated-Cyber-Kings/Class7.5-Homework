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
#### Prerequisites
1. Access to Google Cloud Platform (GCP) with a billing account.
2. Permissions to create and manage Compute Engine resources.
3. Compute Engine API enabled in the GCP project.
4. Create VPC network and subnetwork in a specific region (e.g., us-central1).
5. Add or remove firewall rules to allow traffic to the instances in the instance group.
6. A startup script that will be executed on the first VM initialization of each instance.


#### ClickOps Procedure to Create a Global External HTTP Load Balancer with Cloud Armor and Cloud CDN

Workflow:
1. Create a VPC network and subnetwork in the us-central1 region.
2. Create a Managed Instance Group with 3 instances in the us-central1 region, using the latest CentOS 10 image and allowing HTTP traffic on port 80.
3. Add a named port to the instance group for port 80.
4. Create a firewall rule to allow incoming HTTP traffic on port 80 to the instances in the instance group.
5. Reserve a global static IP address for the load balancer.
6. Setup the load balancer with the following components:
    - Frontend configuration that uses the reserved global static IP address and listens on port 80.    
   - Backend service that points to the instance group and uses the health check.
   - URL map that routes all traffic to the backend service.
   - Target HTTP proxy that references the URL map.
7. Create a Cloud Armor security policy or accept the default policy to protect the load balancer from common web attacks.
8. Create routing rules to direct traffic to the target HTTP proxy.
9. Verify network connectivity to the load balancer by accessing the reserved global static IP address in a web browser.
10. Clean up all resources created in previous steps to avoid unnecessary expenses.

#### VPC Network and Subnetwork Setup
Note: We create a VPC network and subnetwork rather than using the default VPC to ensure that we have an isolated environment to build and deploy these resources.

1. Go to the Google Cloud Console and navigate to VPC network > VPC networks.
2. Click on "Create VPC network".
3. Name the network "mephisto-network".
4. Under "Subnet creation mode", select "Custom".
5. Click "New subnet".
6. Name the subnet "mephisto-subnet".
7. Select the "us-central1" region.
8. Set IP stack type to IPv4 (single stack).
9. Under Primary IPv4 range, enter IP address range "10.100.1.0/24" for the instance group.
10. Click "Create" to create the VPC network and subnet.


#### Managed Instance Group Creation
1. Go to the Google Cloud Console and navigate to Compute Engine > Instance Templates.
2. Click on "Create instance template".
3. Name the instance template "lb-mephisto-template".
4. Set location to Regional and set region to "us-central1".
5. Set machine type to N2D standard with 2 vCPUs and 8 GB of memory.
6. Select Boot disk and click "Change" to select "CentOS 10" from the list of public images and set disk size to at least 20GB.
6. Select Advanced options and scroll down to the "Network interfaces" section.
    - Add Network tags: allow-health-check, allow-http, allow-https
    - Network interfaces: Select edit network interface and set "network" to "mephisto-network" and "subnetwork" to "mephisto-subnet".
 
7. Under "Boot disk", click "Change" and select "CentOS 10" from the list of public images.
8. Under "Management, security, disks, networking, sole tenancy", click on "Management" and in the "Automation" section, add the startup script that you want to run on the instances' first startup.
9. Click "Create" to create the instance template.
10. Create a managed instance group using a instance template:
    - Navigate to Compute Engine > Instance groups.
    - Choose the "New managed instance group (stateless)" option.
    - Name the instance group "mephisto-instance-group".
    - Select the instance template created in the previous step (e.g., "lb-mephisto-template").
    - Set the number of instances to 3.
    - Set location to Single Zone and set region to "us-central1".
    - For zone selection, choose "us-central1-a" or any other zone in the "us-central1" region.
    - Under "Autoscaling", select "On" with minimum number of instances to 2 and maximum number of instances to 5.
    - Click "Create" to create the managed instance group.

#### Create a Named Port    
1. Navigate to Compute Engine > Instance groups in the Google Cloud Console.
2. Click on the instance group you created (e.g., "mephisto-instance-group) and select edit.
3. Scroll down to the "Port Mapping" section and click "Add port".
   - Set the port name to "http" and the port number to "80".
4. Click "Save".

#### Firewall Rule Creation
1. Navigate to firewall policies in the Google Cloud Console.
2. Click on "Create firewall rule".
3. Name the firewall rule "fw-allow-health-check".
4. Select "Network" and select the "mephisto-network" created earlier.
5. Under "Targets", select "Specified target tags" and add the tag "allow-health-check".
6. Under "Source filter", select "IPv4 ranges".
7. Set source IPv4 range to 130.211.0.0/22 and 35.191.0.0/16. [NOTE] These are the IP ranges used by Google Cloud Load Balancing health check probes.
8. Under "Protocols and ports", select "Specified protocols and ports".
9. Check the box for "tcp" and enter "80" in the text field.
10. Click "Create" to create the firewall rule.

#### Reserve a Global Static IP Address
1. Navigate to VPC Network > IP addresses in the Google Cloud Console.
2. Click on "Reserve static address".
3. Name the static IP address "mephisto-static-ip".
4. Set "Network Service Tier" to "Premium".
5. Set "IP version" to "IPv4".
6. Set "Type" to "Global".
7. Click "Reserve" to reserve the global static IP address.

#### Set Up Load Balancer
[NOTE] This runbook only uses HTTP versus HTTPS for connections, so there is no need to acquire SSL certificates.
1. Navigate to Network Services > Load balancing in the Google Cloud Console.
2. Click on "Create load balancer".
3. Set type of load balancer to "Application Load Balancer (HTTP/HTTPS)" and click "Next".
4. Set load balancer name to "mephisto-load-balancer".
5. Select Public facing (external) and click "Next".
6. For Global or single region, select "Best for global workloads" and click "Next".
7. For Load balancer generation, select "Global external Application Load Balancer" and select "Next".
8. Select "Configure".
9. For frontend configuration, click "Frontend configuration" and set the following:
   - Name: mephisto-frontend
   - IP version: IPv4
   - Protocol: HTTP
   - IP address: Select the reserved global static IP address (e.g., "mephisto-static-ip")
   - Port: 80
   - Select "Done" to save the frontend configuration.
10. For backend configuration, click "Backend configuration" and set the following:
    - Name: mephisto-backend    
    - Backend type: Instance group
    - Instance group: Select the instance group you created earlier (e.g., "mephisto-instance-group")
    - Port numbers: 80
    - Click "Create a health check" and set the following:
        - Name: mephisto-health-check
        - Protocol: HTTP
        - Port: 80
        - Request path: /
        - Check interval: 30 seconds
        - Timeout: 10 seconds
        - Health threshold: 3
        - Unhealthy threshold: 3
    - Deselect CDN unless you want to enable Cloud CDN for this load balancer.
    - Leave Cloud Armor security policy as "none" for now.
    - Click "Done" to save the backend configuration.
10. Set "Routing rules" to "Simple Host and Path rules" and click "Next".


#### Validate Load Balancer Functionality
1. Make note of the IP address that is associated with the load balancer frontend configuration (e.g., "mephisto-static-ip").
2. Input the address in a web browser to ensure the load balancer is functioning correctly.
3. Make note of the IP address of each instance and as you refresh the browser, you should see the load balancer distributing traffic across the instances and see a different instance IP address each time you refresh the page.


#### Cleanup
Workflow: We work in reverse order to ensure dependencies are properly handled when deleting resources.

1. Navigate to Network Services > Load balancing in the Google Cloud Console.
2. Click on the load balancer you created (e.g., "mephisto-load-balancer").
3. Click "Delete" to remove the load balancer and all associated components (forwarding rule, target proxy, URL map, backend service).
4. Navigate to Security > Cloud Armor in the Google Cloud Console.
5. Click on the security policy you created (e.g., "mephisto-security-policy").
6. Click "Delete" to remove the Cloud Armor security policy.[NOTE] In this runbook you did not create any policies, however it is a best practice to clean up any policies that were created to avoid unnecessary expenses.
7. Navigate to Compute Engine > Instance groups in the Google Cloud Console. 
8. Click on the instance group you created (e.g., "mephisto-instance-group").
9. Click "Delete" to remove the instance group and all associated instances. You must enter teh word "delete" to confirm the deletion of the instance group and all instances within it.
10. Navigate to Compute Engine > Instance templates in the Google Cloud Console. 
11. Click on the instance template you created (e.g., "lb-mephisto-template"). 
12. Click "Delete" to remove the instance template. You must enter the word "delete" to confirm the deletion of the instance template.
13. Navigate to VPC network > Firewall in the Google Cloud Console.
14. Click on the firewall rule you created (e.g., "fw-allow-health-check). The easiest way to find your firewall rule(S) is to filter by the network you created (e.g., "mephisto-network").
15. Click "Delete" to remove the firewall rule.
16. Navigate to VPC Network > IP addresses in the Google Cloud Console.
- Select the reserved global static IP address you created (e.g., "mephisto-static-ip").
- Select release to remove the reserved global static IP address.
17. Navigate to VPC network > VPC networks in the Google Cloud Console.
18. Click on the VPC network you created (e.g., "mephisto-network").
19. Click "Delete" to remove the VPC network and all associated subnets. You must enter the word "delete" to confirm the deletion of the VPC network and all associated subnets.
20. Review all resources in the GCP project to ensure that all resources created in previous steps have been properly deleted to avoid unnecessary expenses.

Note: Be sure to confirm the deletion of each resource after clicking "Delete" to ensure that all resources are properly removed from your GCP project.



### Terraform Code for Managed Instance Group Creation
#Terraform code is under development under folder named terraform. The final version will be included in the final submission of this assignment.