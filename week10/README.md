# Week 10: Advanced GCP Networking, DNS, and SSL/TLS

## 🌐 DNS and SSL/TLS

### **Explain what the traceroute and dig commands do. Compare and contrast.**

- **traceroute:** Traces the entire path a packet takes from source to destination.
    
    - _Analogy:_ It’s like riding shotgun with an Uber Eats driver from the moment they leave the restaurant to the moment they hit your doorstep. You see every single street turn, stoplight, and delay along the way.
        
- **dig:** Directly queries DNS name servers to look up specific resource records (like IP addresses or mail servers) for a domain.
    
    - _Analogy:_ It’s like searching your phone's contact list to look up a friend's email address or phone number that you already stored.
        
- **Compare & Contrast:** Both are crucial troubleshooting tools. Use `traceroute` to find exactly where a network packet is being dropped (like tracking where an Amazon package got stuck at a specific sorting facility). Use `dig` to verify if a domain's mapping is correct (like looking up your cousin's current phone number to make sure it hasn't changed).
    
- **Source:** [Traceroute (tracert) Explained - Network Troubleshooting](https://www.youtube.com/watch?v=up3bcBLZS74&list=PL7zRJGi6nMRzg0LdsR7F3olyLGoBcIvvg&index=30)
    

---

### **What are the 4 most common DNS records and what are their use cases?**

- **A Record:** Maps a domain name directly to an IPv4 address (e.g., pointing `my-app.com` to your GCP Load Balancer IP).
    
- **AAAA Record:** Maps a domain name directly to an IPv6 address.
    
- **CNAME Record:** Maps a domain name to another domain name (an alias). This is useful for pointing a subdomain to an external service without using a raw IP.
    
- **MX Record:** Specifies the mail servers responsible for receiving email on behalf of the domain.
    
- **Source:** [DNS Records Explained](https://www.youtube.com/watch?v=HnUDtycXSNE&list=PL7zRJGi6nMRzg0LdsR7F3olyLGoBcIvvg&index=13)
    

---

### **Give an overview of the steps in a TLS handshake.**

1. **Client Hello:** The user's browser sends supported TLS versions and cryptographic algorithms (cipher suites) to the server.
    
2. **Server Hello & Certificate:** The server responds with its chosen cipher suite and sends its SSL/TLS public certificate.
    
3. **Authentication:** The browser verifies the certificate against built-in trusted authorities.
    
4. **Key Exchange:** The client and server securely generate a shared **symmetric session key** used to encrypt all actual data moving forward.
    

- _Analogy:_ It's like an ID verification during a high-value UPS delivery. The delivery worker arrives and greets you (**Hello**), they ask for your ID to verify your identity (**Authentication**), you sign the handheld clipboard to authorize the trade (**Key Exchange**), and finally, the secure handoff of the package is complete.
    
- **Source:** [SSL, TLS, HTTP, HTTPS Explained](https://www.youtube.com/watch?v=hExRDVZHhig&list=PL7zRJGi6nMRzg0LdsR7F3olyLGoBcIvvg&index=48)
    

---

### **How does an SSL/TLS cert know what domain it belongs to?**

An SSL/TLS certificate contains specific fields called the **Common Name (CN)** and the **Subject Alternative Name (SAN)**. When a certificate is issued, the domain names it is allowed to protect are hardcoded directly into these fields. The browser reads these fields to make sure they match the URL typed into the address bar.

- _Analogy:_ It's like a real estate property deed. The deed explicitly lists the legal street address (the **CN/SAN**). When the city inspector comes to verify the property, they look at the address written on the deed to ensure it matches the actual physical house (the **domain**) they are standing in front of.
    
- **Source:** [HTTP vs. HTTPS: How SSL/TLS Encryption Works](https://www.youtube.com/watch?v=AB0VMbvEz7g)
    

---

### **What is a certificate authority?**

A Certificate Authority (CA) is a trusted, third-party entity that validates the ownership of a domain and issues digital SSL/TLS certificates. They act as the ultimate "trust anchor" on the internet; browsers inherently trust them to vouch for a website's identity.

- _Analogy:_ The Certificate Authority is like the Government Vital Statistics office. They are the official entity that validates a birth, seals the document, and issues an official birth certificate. Because the government office stamped it, banks, schools, and employers inherently trust that the identity is real.
    
- **Source:** [http vs https | How SSL (TLS) encryption works in networking ? (2023)](https://www.youtube.com/watch?v=eWdPWSBKxso)
    

---

## ⚖️ Load Balancers & Cloud DNS

### **How do application load balancers in GCP offload (decrypt) SSL? What part of the load balancer does this?**

Application Load Balancers in GCP offload SSL via a component called a **Target Proxy** (specifically a Target HTTPS Proxy). The Target HTTPS Proxy terminates the incoming user-facing SSL/TLS connection at the edge of Google's network, decrypts the request using the attached SSL certificate, and evaluates the URL map to route the traffic.

- _Analogy:_ It’s like a polyglot translator standing at the entrance of a global conference. Instead of making every internal team member learn 50 different languages, the translator stands at the door, speaks to all the incoming international visitors, converts their requests into a single standard language, and hands the clear instructions over to the back-office staff.
    
- **Source:** [Target proxies overview](https://docs.cloud.google.com/load-balancing/docs/target-proxies)
    

---

### **Are there use cases to have in-flight encryption from the backend service to the backend itself?**

Yes. This is used when implementing a strict **Zero Trust Architecture**. Even though terminating SSL at the load balancer saves computing power, you re-encrypt the traffic on its way to the backend instances to satisfy strict compliance regulations (like HIPAA or PCI-DSS). This prevents any potential internal packet sniffing inside the VPC network and ensures data is encrypted at every single step.

- **Source:** [Encryption from the load balancer to the backends](https://docs.cloud.google.com/load-balancing/docs/ssl-certificates/encryption-to-the-backends)
    

---

### **Can multiple domains end up pointing to the same LB?**

Yes. You can map as many domains or subdomains as you want to a single Load Balancer by creating multiple DNS records that point to the same Anycast frontend IP address. The Load Balancer uses its routing rules to sort the traffic afterward.

- _Analogy:_ This is like multiple family members using the same house address to receive Amazon orders. The names on the packages are completely different, and the items are coming from different vendors, but they all ship to a single mailbox (the Anycast IP). Once the packages land in the living room, they are sorted out to the correct individual.
    
- **Source:** [Google Cloud DNS Full Course - Setup Custom Domain Step by Step](https://www.youtube.com/watch?v=NDtzhr_1k8g)
    

---

### **In the context of Cloud DNS, what are zones?**

A managed zone is a container for all the DNS records (like A, CNAME, and TXT records) belonging to the same domain name suffix (e.g., `my-app.com`). It acts as the database that tells Google Cloud DNS how to handle routing requests for that specific domain space.

- _Analogy:_ Think of a managed zone like a dedicated "Company Directory" binder. The binder itself represents the domain (`company.com`). Inside that binder, you have individual index cards (DNS records) showing that the IT department is on Floor 1 (A Record) and HR can be reached by calling the front desk alias (CNAME). It groups all internal department listings under one corporate roof.
    
- **Source:** [Cloud DNS overview](https://docs.cloud.google.com/dns/docs/overview)

Broken Env RUNBOOK:


## 🧾 Part 1: Detailed Root Cause Analysis (RCA)

When you first inherited the environment from the "drunk engineer," the architecture was completely isolated due to misconfigurations across three different layers: **Compute, Networking, and Firewall Access Control.**

|**#**|**System Layer**|**Sabotaged Configuration Found**|**Technical Impact**|**Remediation Action**|
|---|---|---|---|---|
|**1**|**Compute**|VM Instance State: `Stopped`|The web server application (Apache) cannot listen for packets if the underlying CPU is powered off.|**Started** the `homework-vm` instance via the console.|
|**2**|**Networking**|External IP Mapping: `None`|The VM was locked within the private `10.10.0.0/24` subnet with no public-facing routing table attachment, making it unreachable from the internet.|Modified the VM's network interface (`nic0`) and assigned an **Ephemeral External IP**.|
|**3**|**Firewall**|Implicit Deny Injection: `homework-deny-all`|A catch-all `DENY` rule was created at **Priority `0`**. Because lower numbers take precedence in GCP, it dropped all ingress traffic before any other rules could execute.|**Deleted** the rogue deny rule completely from the VPC.|
|**4**|**Firewall**|Strict CIDR Filtering: `homework-allow-ssh`|The source filter for SSH traffic was locked down exclusively to a single, foreign IP address (`1.2.3.4/32`).|Broadened the source range filter to **`0.0.0.0/0`** to accept incoming administrative connections.|
|**5**|**Firewall / IAM**|Evaluation Hierarchy Mismatch & Missing Tags|The custom rules were set to Priority `1005` and `1006`, causing them to be evaluated _after_ GCP's built-in default network block rules. Additionally, the VM lacked the `http-server` tag.|Lowered rule priorities to **`995`** and **`997`** to bypass defaults, and appended **`http-server`** to the VM's network tags.|

---

## 🛠️ Part 2: Final Step-by-Step Runbook Guide

You can copy and paste this direct, reproducible script template into your final lab documentation. It proves exactly how to verify and fix the environment sequentially.

### Phase 1: Compute & Routing Verification

1. **Check Virtual Machine State:** Navigate to [VM instances in the Compute Engine Console](https://console.cloud.google.com/compute/instances?cloudshell=true&project=class75-491118). If the status icon is grey/stopped, highlight the row and click **Start**.
    
2. **Examine Edge Networking:** Select the VM, scroll down to Network Interfaces, and verify if an External IP exists. If missing, click **Edit**, modify the primary network interface configuration, toggle the External IP dropdown to **Ephemeral**, and click **Save**.
    

### Phase 2: Ingress Firewall Remediation

1. Navigate to the [GCP Firewall Policies Dashboard](https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/list?project=class75-491118).
    
2. **Clear Priority-0 Blocks:** Locate any explicit `Deny` rules carrying a priority lower than 1000. Select the rule and click **Delete**.
    
3. **Correct Rule Priorities:** Open your custom rules and scale down their priority metadata below the `1000` default threshold:
    
    - **`homework-allow-ssh`** $\rightarrow$ Set Priority to **`995`**
        
    - **`homework-allow-http`** $\rightarrow$ Set Priority to **`997`**
        
4. **Fix Source Network Restrictions:** Edit `homework-allow-ssh`. Wipe out the static `1.2.3.4/32` parameter and adjust the **Source IPv4 Ranges** box to broad exposure (`0.0.0.0/0`).
    

### Phase 3: Identity & Network Tag Alignment

1. Open the configuration panel for `homework-vm` and click **Edit**.
    
2. Scroll to the **Network Tags** section.
    
3. Ensure both target markers are assigned inside the array concurrently:
    
    Plaintext
    
    ```
    [ ssh-access ] [ http-server ]
    ```
    
4. Click **Save** to distribute the routing tables to the hypervisor edge.
    

---

## 🏁 Phase 4: Verification & Validation Testing

To prove to your instructor that the runbook succeeded, run the following regression tests from your Cloud Shell console using the newly assigned external endpoint (`104.154.116.8`):

### Test A: Port 22 Remote Administration Access

Bash

```
gcloud compute ssh homework-vm --zone=us-central1-a
```

- **Expected Output:** The terminal negotiates the ephemeral cryptographic handshake, maps your user profile, and securely alters your command prompt to `ares_carter@homework-vm:~$`.
    

### Test B: Port 80 Web Application Traffic Ingress

Bash

```
curl http://104.154.116.8
```

- **Expected Output:** The firewall passes the HTTP request cleanly, matching against the active Apache thread running locally within the Linux operating system, and returns the successful lab completion banner:
    
    HTML
    
    ```
    You fixed the VM! Yay!
    ```


