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

    Load Balancing Routing Rules example: An example of a load balancing routing rule could be a Geo-Routing rule where the rule would send a user to a specific IP address or geographic location closest to that user.
<br/>
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

## Runbook for creating a Fully Configured External Application Global Load Balancer, with a Managed Instance Group as a backend!
<br/>
<br/>

Prequisites:
<br/>

* Google Cloud Account (Free Trial)
* Instance Template
<br/>
<br/>

1) Click on create instance group button

<img width="2880" height="1650" alt="001" src="https://github.com/user-attachments/assets/df6d1b95-8f38-4d2f-8f47-b110b01d4745" />
<br/>
<br/>

2) Give your instance a name, copy it to the details, and select your previously created template instance
<br/>
<br/>

<img width="2880" height="1650" alt="002" src="https://github.com/user-attachments/assets/49b51d35-635d-4278-91a0-7e98145a3f97" />
<br/>
<br/>

3) Select the number of Virtual Machine instance you would like your Instance Group to create and maintain

<img width="2880" height="1650" alt="003" src="https://github.com/user-attachments/assets/8fbf1df2-d415-4ef2-b08c-102af27c221f" />
<br/>
<br/>

4) Scroll down to Autohealing, and select Health Checks. Create a Health Check!

<img width="2880" height="1650" alt="004" src="https://github.com/user-attachments/assets/22e4d3a8-fb48-48ed-94d4-4f99d8087d4a" />
<br/>
<br/>

5) Give your health check a name, turn on your logs, and leave the rest of the settings the same.

<img width="2880" height="1650" alt="005" src="https://github.com/user-attachments/assets/14b5f02a-06a7-4081-8244-6dc67805e4d8" />
<br/>

& 
<img width="2880" height="1650" alt="006" src="https://github.com/user-attachments/assets/43c3d63c-11c5-4970-a56a-600546bea2ec" />
<br/>
<br/>

6) Click on the Create button, to create your Instance Group.

<img width="2880" height="1650" alt="007" src="https://github.com/user-attachments/assets/6e5418cf-7db6-4ee4-bb80-7758154517d7" />
<br/>
<br/>

7) Let's check the status of Instance Group by clicking this button. Wait a few minutes, and allow your VM instance to become healthy by allowing health checks.

<img width="2880" height="1650" alt="008" src="https://github.com/user-attachments/assets/33852573-1db3-460d-b927-be73b74db9f6" />

<br/>
<br/>

8) All of my instances that were created by the Instance Group are now healthy! Now, let's create a Load Balancer!

<img width="2880" height="1650" alt="009" src="https://github.com/user-attachments/assets/e59700fd-258e-4561-9ae0-dc151779ca97" />
<br/>
<br/>

9) In a new tab, in GCP console, type Load Balancer in the search bar

<img width="2880" height="1650" alt="010" src="https://github.com/user-attachments/assets/4c1130a5-2709-4686-80f5-ea04778e3450" />
<br/>
<br/>

10) Click on Create Load Balancer

<img width="2880" height="1650" alt="011" src="https://github.com/user-attachments/assets/676abb1c-a217-42f3-b20d-898cbdc9f530" />
<br/>
<br/>

11) Click on Application Load Balancer

<img width="2880" height="1650" alt="012" src="https://github.com/user-attachments/assets/d7a27513-87dd-400d-8655-b7916f6e062b" />
<br/>
<br/>

12) Click on Public facing (external)

<img width="2880" height="1650" alt="13" src="https://github.com/user-attachments/assets/bf1b185f-7216-4fca-8705-97dfedb8ced7" />
<br/>
<br/>

13) Click on Global Workloads

<img width="2880" height="1650" alt="014" src="https://github.com/user-attachments/assets/2cd241e4-5411-44c9-bba4-94b6f9b6c9dd" />
<br/>
<br/>

14) Click on Global external Application Load Balancer

<img width="2880" height="1650" alt="015" src="https://github.com/user-attachments/assets/a83bd246-09a5-432b-8d74-9688b78b7912" />
<br/>
<br/>

15) Click on Configure

<img width="2880" height="1650" alt="016" src="https://github.com/user-attachments/assets/43a3bacf-5d18-4d58-8c69-ffdf22018b14" />
<br/>
<br/>

16) Create FrontEnd IP & Port

<img width="2880" height="1650" alt="017" src="https://github.com/user-attachments/assets/59f1d111-50d1-4f3e-af0d-5c18e4e914a3" />
<br/>
<br/>

17) Give Load Balancer a name, create backend service and bucket

<img width="2880" height="1650" alt="018" src="https://github.com/user-attachments/assets/9f8aadc7-b1d3-4124-8286-765d40ab9c05" />
<br/>
<br/>

18) Give backend service a name and a description, and choose your health check

<img width="2880" height="1650" alt="019" src="https://github.com/user-attachments/assets/7e261f36-09d6-43c1-9eb1-30df0393d461" />
<br/>
<br/>

19) Choose your Instance Group, make sure your ports are set to "80", and click on Done.

<img width="2880" height="1650" alt="020" src="https://github.com/user-attachments/assets/ab105bf5-f174-47a4-8f0d-4e900f0d8767" />
<br/>
<br/>

20) Scroll down, and make sure "Cloud CDN" is unchecked.

<img width="2880" height="1650" alt="021" src="https://github.com/user-attachments/assets/0ceb6657-ebe4-42f9-a4e1-ea4a64f51cd4" />
<br/>
<br/>

21) Don't create a backend bucket, just click on the OK button.

<img width="2880" height="1650" alt="022" src="https://github.com/user-attachments/assets/f75ca94f-f4ce-4ad4-8cbd-792739cf6070" />
<br/>
<br/>

22) Click on the Create button at the bottom of the screen, to create your Load Balancer.

<img width="2880" height="1650" alt="023" src="https://github.com/user-attachments/assets/2ba7d844-981b-4773-b258-28fc91426a6b" />
<br/>
<br/>

23) Click on your Load Balancer name.

<img width="2880" height="1650" alt="024" src="https://github.com/user-attachments/assets/2f389e01-7dc3-490c-b34f-6f6da63548fb" />
<br/>
<br/>

24) Copy your Load Balancer's IP Port, and insert "http://" in front of that port and insert that into your web browser.

<img width="2880" height="1650" alt="025" src="https://github.com/user-attachments/assets/b5d83acd-b2a5-4925-99b4-cccf0f2bfa0b" />
<br/>
<br/>

25) That web address should bring you to this webpage, but pay attention to the Internal & External IP, because it should change every 10 seconds to a new region's configuration.

<img width="2880" height="1650" alt="026" src="https://github.com/user-attachments/assets/3599ebc8-33e7-4c8d-b013-8f6d79d0c3ce" />
<br/>
<br/>

26) 10 seconds later...LOL

<img width="1536" height="1024" alt="10 seconds later" src="https://github.com/user-attachments/assets/c6be65d9-491c-45f5-a82e-8e18f9e54bc3" />
<br/>

👇 Notice that the Internal & External IP changed again...
<br/>

<img width="2880" height="1650" alt="027" src="https://github.com/user-attachments/assets/f06d9004-5cc1-4ff3-abec-3ecefd39b59e" />

27) A few moments later...

<img width="800" height="600" alt="few_moments_later_spongebob_by_psddude_djja51n-414w-2x" src="https://github.com/user-attachments/assets/c83e5fc4-bd48-41a2-972a-3bb83409180e" />
<br/>

👇 Notice that the Internal & External IP changed once more to another region...
<br/>

<img width="2880" height="1650" alt="028" src="https://github.com/user-attachments/assets/e8006660-48c7-46ec-83f6-890420f47e1b" />
