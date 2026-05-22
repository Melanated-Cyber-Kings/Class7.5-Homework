# Individual Work: Q&A

---

## DNS and SSL/TLS

### What do the `traceroute` and `dig` commands do? Compare and contrast.

**traceroute** (also called a "journey tracker") shows the hops and how long each hop takes. It is a tool used to track down the path that data packets take from one computer to another across a network like the internet.

**dig** is used to troubleshoot DNS problems (the "address book lookup").

---

### What are the 3 or 4 most common DNS records and what are their use cases?

**a) A Record (Address Record)**
Maps a domain name to an IPv4 address.
- *Use case:* Serving a website or app from an IP. Example: `192.0.2.1`

**b) CNAME (Canonical Name)**
Points one domain name to another domain name (not an IP) — just like a nickname.
- *Use case:* Used for subdomains or when you want multiple domain names to point to the same location. For instance, `www.techjiji.com` might be a CNAME pointing to `techjiji.com`.

**c) MX (Mail Exchanger)**
Tells mail servers where to deliver email for the domain.
- *Use case:* Routing email to Google Workspace, Microsoft 365.

**d) TXT Record**
Stores plain text info about your domain.
- *Use case:* Used for verification and security — proving you own a domain.

---

### Give an overview of the steps in a TLS handshake.

1. **Client Hello** — The browser kicks off the handshake saying "Hey, I want to connect securely. And these are the encryption methods."

2. **Server Hello** — The server responds, selecting an encryption method and sending its certificate for authentication.

3. **Server Certificate and Authentication** — The server hands over its TLS certificate. Think of this like showing a government-issued ID. The certificate says "I really am google.com, and here's proof signed by a trusted authority."

4. **Browser Verifies the Certificate** — The browser checks that the certificate was verified by a trusted Certificate Authority (CA). This is where the padlock icon either appears or a warning fires.

5. **Key Exchange** — Both client and server agree on a shared symmetric key that will be used for encryption/decryption during their session.

6. **Finished** — Both sides send a "handshake complete" message encrypted with the new key. If both can read each other's messages, they know the setup worked.

---

### How does an SSL/TLS cert know what domain it belongs to?

When you try to connect to a website (e.g. `x.com`) in a browser, the browser asks the server to identify itself — essentially asking "Hey, are you x.com?" The server responds with "Yeah, it's me" and presents its SSL certificate as proof. When both the browser and server are satisfied, they perform a virtual handshake and agree to send data to one another.

> Reference: https://www.youtube.com/watch?v=eWdPWSBKxso

---

### What is a Certificate Authority?

A Certificate Authority (CA) is a trusted entity that validates ownership of a domain and issues SSL/TLS certificates.

---

## Load Balancers

### How do Application Load Balancers in GCP offload (decrypt) SSL? What part of the load balancer does this?

The GCP Application Load Balancer sits between your users and your servers. When a user's browser sends an HTTPS request, it hits the load balancer first. The specific part that handles the encryption is called the **target HTTPS proxy** — this is where your SSL certificate lives, and it is the component that performs the TLS handshake.

Once the proxy decrypts the traffic, it passes it as plain HTTP through a **URL map** (which decides which backend to send it to) and a **backend service** (which manages your VMs and health checks), before finally landing on your actual servers. Your VMs never see any encrypted traffic at all — they just receive normal HTTP as if there was no encryption involved. This is called **SSL offloading**, and you only have to manage your SSL certificate in one place rather than on every single VM.

> Reference: https://docs.cloud.google.com/load-balancing/docs/target-proxies

---

### Are there use cases to have in-flight encryption from the backend service to the backend itself?

Yes, there are use cases for keeping traffic encrypted all the way to your backend VMs. The most common reasons include:

- **Compliance** — Industries like healthcare (HIPAA) and finance (PCI-DSS) legally require encryption everywhere, and "it's inside our VPC" won't satisfy an auditor.
- **Zero Trust security model** — Organisations that don't automatically trust internal network traffic encrypt every hop regardless.
- **Shared infrastructure** — If your infrastructure is shared across multiple teams or customers.
- **Contractual requirements** — A specific customer contract may mandate end-to-end encryption.

In GCP, this is handled by configuring your backend service to use HTTPS instead of HTTP when forwarding to your VMs, meaning your VMs need their own certificates installed. Google's Certificate Authority Service can help manage those at scale.

---

## Cloud Domain/DNS

### Can multiple domains end up pointing to the same load balancer?

Yes, multiple domains can point to the same Load Balancer, which is a common industry practice used to reduce costs and simplify infrastructure management. This is achieved by:

- Pointing the DNS records (CNAME) for various domains to a single Load Balancer address.
- The Load Balancer uses **host-based routing** to inspect the incoming HTTP Host Header and direct traffic to the correct backend service.
- For security across different domains, the Load Balancer uses **Server Name Indication (SNI)**, allowing it to host multiple SSL certificates on a single IP address and present the correct one during the TLS handshake.

---

### In the context of Cloud DNS, what are zones?

A zone is a container for a specific domain name (like `myproject.com`) and all the subdomains under it (like `api.myproject.com` or `test.myproject.com`). It gives you a dedicated sandbox to manage how traffic routes to your cloud resources.

Think of Cloud DNS as the internet's giant phonebook — it translates human-friendly addresses like `yourcompany.com` into raw numeric IP addresses (like `34.102.112.22`) that computers use to find each other. In GCP, a DNS Zone is simply a specific folder or "chapter" inside that phonebook that you own and control.

> Reference: https://docs.cloud.google.com/dns/docs/zones

---

## Runbook: Unavailable Service

### Problem Statement

A "drunk engineer" attempted to make changes to the environment and broke several things. The Virtual Machine (VM) is not accessible as a web server via its public IP address, and SSH access to the VM is not working.

### Steps Taken

**1.** Accessed the GCP console to understand the architecture and identify services associated with the VM.

**2.** Noticed the VM was greyed out (stopped). Started the VM.

**3.** Added an external IP address to the VM, as it only had a private IP address.

**4.** Deleted the deny-all firewall rule that was blocking all ingress traffic to the VM.

**5.** Added the `http-server` tag to the VM to allow HTTP traffic.

**6.** Adjusted the SSH source IP rule from client range to `0.0.0.0/0`.

**7.** Added a default gateway to the VPC:

```bash
gcloud compute routes create default-internet-route \
  --network=homework-vpc \
  --destination-range=0.0.0.0/0 \
  --next-hop-gateway=default-internet-gateway
```

**8.** Ran ping commands to verify connectivity:

```bash
ping 8.8.8.8
```

**9.** Installed and started the Apache server, then added content to `index.html`:

```bash
apt update
apt install -y apache2
systemctl start apache2
echo "You fixed the VM! Yay!" > /var/www/html/index.html
```