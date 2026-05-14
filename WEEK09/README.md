# Cloud Networking & Load Balancing

---

## Table of Contents

- [Load Balancers](#load-balancers)
- [Cloud Armor](#cloud-armor)
- [Cloud CDN](#cloud-cdn)
- [Runbook: Global Application Load Balancer Setup](#runbook-global-application-load-balancer-setup)

---

## Load Balancers

### How does load balancing contribute to Fault Tolerance? What about High Availability?

**Fault Tolerance** is the ability of a system to keep running even when there is a break in the system.

If one of your servers suffers a hardware failure, the load balancer instantly detects the dead server and stops sending traffic to it, instead routing user traffic to the healthy servers that remain. The failed server is bypassed and the user never experiences downtime.

**High Availability** is all about uptime — ensuring the system is up and running almost 100% of the time.

A load balancer contributes to HA by pooling multiple servers together. For instance, if you have 10 servers and a massive surge of users visits your site, the load balancer spreads the work evenly so no single server gets overwhelmed.

---

### Do global load balancers decrease latency for end users? Why or why not?

Latency is largely a function of physical distance.

**Yes** — a global load balancer can reduce latency. The farther your data travels, the longer it takes. If all your servers are in the US and a user in Nairobi makes a request, that data enters Google's network at the closest point of presence and travels over to the nearest backend.

A global load balancer solves this by routing each user to the server region closest to them. If you have servers in the US, Europe, and Asia, a Nairobi user might be sent to the European region instead, saving hundreds of milliseconds off the round-trip time.

---

### What are LB health checks for? Do we always need them? Is a LB different from a reverse proxy?

**Health checks** are recurring "are you alive?" pings that the load balancer sends to each backend server. The LB might ask: "Can you accept HTTP traffic? Can you connect on port 8080? Does this URL respond with a 200 OK?" If a server fails to respond correctly, the LB marks it as unhealthy and stops routing traffic to it.

**Do we always need them?** Yes. Without health checks, a load balancer is blind — it might send users to a crashed server, resulting in an error page.

**Is a LB different from a reverse proxy?** They are very similar. A load balancer is a type of reverse proxy. A reverse proxy sits in front of servers and forwards client requests, often handling things like SSL termination and caching. A load balancer specifically distributes traffic across multiple backends.

---

### What are LB routing rules and URL maps for? Give an example or two.

Routing rules and URL maps tell the load balancer where to send specific requests based on the URL path and hostname. Instead of sending everything to one place, you can split traffic based on what the user is asking for.

**Example:**
Requests to `images.example.com` get routed to a Cloud Storage bucket serving static images, while `app.example.com` goes to a group of Compute instances running the application.

---

### Explain what an Anycast IP address is used for in the context of a global load balancer.

An Anycast IP is a single IP address that is announced from many locations around the world at once. In the context of a global load balancer, this means your application has a single public IP address that users anywhere in the world connect to. A user in Nairobi, a user in London, and a user in Tokyo all point to the same IP — but each of them gets routed to the Google edge location nearest to them, which then passes the request to the appropriate backend.

---

## Cloud Armor

### What does Cloud Armor offer?

Cloud Armor is Google Cloud's Web Application Firewall (WAF) and DDoS protection service. Think of it as a digital bouncer for your applications. It lets you define rules to allow, deny, or rate-limit traffic to your applications based on things like IP address, geographic location, request patterns, and known attack signatures such as SQL injection.

### Why is it used in the first place?

It is used to protect web applications from malicious traffic and attacks before the traffic even reaches your servers.

---

### What layer in the OSI model does it operate at? Why is this important and how is it different from VPC firewall rules?

Cloud Armor operates primarily on **Layer 7 — the Application Layer**.

**Why it's important:** Many attacks are crafted to look like legitimate network traffic at a lower layer but contain malicious payloads in the HTTP body or URL. A Layer 7 firewall can catch this; a lower-layer firewall cannot.

**VPC firewall rules** operate at **Layers 3 and 4** — the Network and Transport layers — and work with IP addresses and ports.

---

### What are rate-based rules for?

Rate-based rules limit how many requests a single client or specific IP can make in a given time window. They are effective at stopping brute-force attacks.

---

### What is reCAPTCHA and how does it relate to Cloud Armor?

reCAPTCHA is Google's service for distinguishing human users from automated bots (e.g. "click all the traffic lights"). It acts as a middle ground between allowing all traffic and blocking all traffic. Cloud Armor can redirect suspicious requests to a reCAPTCHA challenge — if the challenge is passed, the user is allowed through; if failed, they are blocked.

---

## Cloud CDN

### What are POPs used for?

POPs (Points of Presence) are physical data centers located in major cities around the world. Cloud CDN uses POPs to store copies of your website or system files close to users. For example, if your main server is in London but you have a user in Kenya, the Kenyan POP will hold a cached copy of your site, so the user downloads it from the local POP — resulting in faster load times.

---

### What kind of files are served with Cloud CDN?

Cloud CDN serves **static files** — files that don't change often — such as images (JPEG, PNG), videos, and audio files.

---

### What services can be used with Cloud CDN as the origin?

The origin is where Cloud CDN fetches content from when it doesn't have a cached copy. In Google Cloud, the origin can be:

- **Cloud Storage Bucket** — good for storing images and videos
- **Compute Engine** — VM instances
- **GKE** — Google Kubernetes Engine

---

### Does Cloud CDN help protect against any types of malicious actors or cyberattacks?

Yes. While Cloud CDN is primarily built for performance and speed rather than security, it does provide some indirect security benefits:

1. **DDoS (Distributed Denial of Service) attacks** — Attackers flood your site with massive numbers of requests to crash your servers. With Cloud CDN, those requests hit Google's global network POPs, which absorb them rather than letting them reach your origin server.

---

### Should an enterprise always use Cloud CDN? Why or why not?

**No** — it depends on the use case.

**Use Cloud CDN when:**
- Running an e-commerce platform or media streaming service, where CDN saves on bandwidth costs and speeds up load times.

**Avoid Cloud CDN when:**
- The application is used internally by a small number of employees (e.g. 50 people in one building).
- The application syncs real-time data, such as live stock trading, where data changes every second or minute and caching provides no benefit.

---

### What is TTL and how does it control content "freshness"?

**TTL (Time To Live)** is a timer that tells a CDN how long to keep a file in its cache before it expires and fetches a fresh copy from the origin.

- If the TTL is still active, the cached file is served instantly.
- If the TTL has expired, the CDN fetches fresh content from the origin, caches it again, and serves it to the user.

---

## Runbook: Global Application Load Balancer Setup

The aim of this runbook is to create a fully configured Application Global Load Balancer using ClickOps, with a Managed Instance Group (MIG) as the backend.

### Prerequisites

- Google Cloud Account (Free tier is sufficient)
- An existing Instance Template

---

### Step 1 — Instance Group (MIG) Setup

1. Navigate to **Instance Groups** and click **Create Instance Group**.
2. Provide a name of your choice (follow naming guidelines) or use the default.
3. Select **Instance Template** and choose your already-created template.
4. Set **Number of instances** to `4` (for testing purposes).
5. Set **Location** to **Multiple zones** for High Availability and Fault Tolerance.
6. Under **Autoscaling**, select **Configure Autoscaling** and set the minimum number of instances (default is fine for testing).
7. Under **Autohealing**, select **Health check > Create health check**.
8. Name it `my-health-check`, set scope to **Regional**, turn **Logs** on, and click **Save**.
9. Click **Create** to initialize the Instance Group.
10. Click the name of your created Instance Group and wait a few minutes for the VM instances to become healthy.

> Autohealing and health checks allow you to monitor application status.

---

### Step 2 — Load Balancer Configuration

1. Search for **Network Services**, then select **Create a load balancer**.
2. Under **Type of load balancer**, keep the default and select **Next**.
3. Keep **Public facing (external)** selected and choose **Next**.
4. Select **Best for global workloads** for Step 3, then choose **Next**.
5. Select **Global external Application Load Balancer**, then select **Next**.
6. Choose **Configure** to continue.

**Frontend Configuration:**
- Name it `my-first-front`.
- Keep defaults: Protocol (`HTTP`), IP version (`IPv4`), IP address (`Ephemeral`), Port (`80`).

**Backend Configuration:**
- Name the service `my-first-back`.
- Set **Backend type** to **Instance group**.
- Under **Health Check**, select **Create a health check**, name it `my-backend-health-check`, keep defaults, and click **Create**.
- Under **New Backend**, choose the Instance Group you created and enter `80` for Port numbers. Keep all other defaults and click **Create**.

7. Scroll down and ensure **Cloud CDN** is **unchecked**.

**Routing Rules:**
- Keep defaults.
- Verify that Backend 1 is set to `my-first-back`.

8. Select **Review and finalize**, verify your configuration, and click **Create**. Wait for the load balancer to be provisioned (this may take a few minutes).
9. Click on your load balancer name `my-first-back` after it is created.
10. Copy the load balancer's IP address and paste it in your browser in the following format:

```
http://<your-IP-address>
```

> Do not include `:80` at the end. You should see a preview of a webpage. Refresh a few times and notice the IP address changing as traffic is distributed across instances.

---

### Cleanup — Destroying Resources

To avoid incurring unnecessary costs, delete resources in the following order:

1. **Load Balancer:** Navigate to **Load Balancing**, select your ALB, and click **Delete**.
2. **Instance Groups:** Navigate to **Compute Engine**, click **Instance Groups** from the side panel, select your group, click the three-dot menu, and select **Delete**.
3. **Instance Template:** All active resources are now destroyed. You may leave the Instance Template for future use as it incurs no cost.