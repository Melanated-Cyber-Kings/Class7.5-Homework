# Q&A

## Explain what the traceroute and dig commands do. Compare and contrast. 
- `traceroute` is used to send packets to a destination in order to see if the connection is working and proving that the packet has reached that point. 
- `dig` is used to check the DNS to see how the internet translates a domain name into an IP address or handles mail exchange.
- While they both are network diagnostic tools but traceroute gives more information as it shows the time to live and how long the packets took to reach their destination. Therefor showing where in the connection things are slowing down and dropping. 
- https://www.ibm.com/docs/en/aix/7.2.0?topic=d-dig-command

## What are the 3 or 4 most common DNS records and what are their use cases?

1. NS record - stores the name server for a DNS entry
2. MX record - directs mail to an email server
3. A record - the record that holds the IP address of a domain
4. CNAME record - forwards one domain or subdomain to another domain, doesnt provide an ip address
- https://www.cloudflare.com/learning/dns/dns-records/

## Give an overview of the steps in a TLS handshake. 

1. The users browser sends a `ClientHello` message to the intnded server when you request a secure website.
2. The server responds with a `ServerHello` message
3. The server presents the users browser with its digital certificate
4. The users browser validates the certificate, then uses the servers public key to encrypt a unique session key and sends it back to the server.
5. The server decrypts the session key with its private key.
6. The server and client then compute the session key, which will be used for further encryption of all communication.
- https://www.ssl.com/article/ssl-tls-handshake-ensuring-secure-online-interactions/

## How does an SSL/TLS cert know what domain it belongs to?

- The certificate contains a public key that authenticates the website's identity and allows for encrypted data transfer.
- The specific domains and subdomains the certificate is authorized to protect are listed inside the certificate file.
- https://www.ssl.com/article/the-essential-guide-to-multi-domain-ucc-san-certificates/

## What is a certificate authority?/
- A Certificate Authority is a trusted organization that issues digital certifiates to websites, businesses, and individuals. 
- When issuing a TLS/SSL certificate, a CA verfies the website domain and the organization behind it.
- Builds trust between users and websites
- If you visit a website and see `HTTPS` or a padlock icon in the address bar, a CA has verified that site and issued a TLS/SSL certificiate.
- https://www.digicert.com/blog/what-is-a-certificate-authority

## How do application load balancers in GCP offload (decrypt) SSL? What part of the load balancer does this? 
- Application Load Balancers use Google Front Ends to terminate the secure connections at the load balancing layer. 
- https://www.huntress.com/cybersecurity-101/topic/ssl-offloading
- https://docs.cloud.google.com/load-balancing/docs/application-load-balancer

## Are there use cases to have in flight encryption from the backend service to the backend itself?
- having in flight encryption between backend services and the backend itself would keep plaintext data from ever beign in the backend network stack. 
- this could be good in case of insider threats, account hijacking, data breaches, and man in the middle attacks.
- basically it would keep your data safe in case of anything that happens within the organization from those that are apart of it and any failures that could possibly happen within the systems stored information.
- https://www.cloudoptimo.com/blog/the-importance-of-data-encryption-in-cloud-environments/

## Can multiple domains end up pointing to the same LB? 
- Yes since Google LB doesn't strip out Host request-header field, you can serve different domains on a single virtual machine behind an LB.
- https://groups.google.com/g/gce-discussion/c/gXHAzSC0kMM

## In the context of Cloud DNS, what are zones?
- **Forwarding Zones** - let you configure target name servers for specific private zones
- a way to implement outbound DNS forwarding from your VPC network
- **Peering Zones** - lets you send DNS requests between Cloud DNS zones in different VPC networks
- allows you to have one network (DNS consumer network) forward DNS requests to another network (DNS producer network), which then performs DNS lookups.
- DNS peering is a one-way relationship. It allows Google Cloud resources in the DNS consumer network to look up records in the peering zone's namespace as if the Google Cloud resources were in the DNS producer network.
- **Managed Reverse lookup zones** - a private zone with a special attribute that instructs Cloud DNS to perfrom a PTR lookup against Compute Engine DNS data. 
- **Zonal Cloud DNS zones** - lets you create private DNS zones that are scoped to a Google Cloud Zone only.
- are created for GKE when you choose a cluster scope
- a new private Cloud DNS service that exists within each Google Cloud Zone.
- https://docs.cloud.google.com/dns/docs/zones/zones-overview

# Runbook

## Incident
- A drunken cloud engineer thought he was smart and updated some settings. The engineer managed to break several things and the VM is not accessible as a web server on the public internet and ssh does not work. 

## Goal
- troubleshoot and repair a VM that does not work correctly
- create a runbook so in the future drunken engineers can troubleshoot their own issues
- document all methods used even if they did not find the current issue as they mat be helpful in the future.

## Troubleshooting steps

**I used GCP's walkthrough for Troubleshooting VM shutdowns and reboots.  https://docs.cloud.google.com/compute/docs/troubleshooting/troubleshooting-reboots**

- First, I went to the terminal and used the command `gcloud compute instances list` which gave me this output:
```
NAME         ZONE           MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP  STATUS
homework-vm  us-central1-a  e2-micro                   10.10.0.2                 TERMINATED

```
- this showed me that there is no external IP so I can't HTTP into the VM and the **drunken engineer stripped the public network configuration**
- **To diagnose the cause of an instance's spontaneous shutdown or reboot, you must query your instance's logs.*
- Next I went to the **Logs Explorer** page to check the VM logs - **Query Cloud Audit Logs to display a list of system events and administrative activities that might have caused the shutdown or reboot.*
- In one of the logs I saw this output:
```
{
insertId: "-yx3o3udtz6c"
labels: {1}
logName: "projects/seir-project-490500/logs/cloudaudit.googleapis.com%2Factivity"
operation: {3}
protoPayload: {
@type: "type.googleapis.com/google.cloud.audit.AuditLog"
authenticationInfo: {3}
authorizationInfo: [1]
methodName: "v1.compute.instances.deleteAccessConfig"
request: {3}
requestMetadata: {4}
resourceLocation: {1}
resourceName: "projects/seir-project-490500/zones/us-central1-a/instances/homework-vm"
response: {14}
serviceName: "compute.googleapis.com"
status: {0}
}
receiveTimestamp: "2026-05-22T03:35:39.230754599Z"
resource: {2}
severity: "NOTICE"
timestamp: "2026-05-22T03:35:38.425727Z"
}
```
- this output showed me that there was a request made to delete the access configuration (`methodName: "v1.compute.instances.deleteAccessConfig"`)
- I went into the console and edited the VM by going to the Firewall section and allowing HTTP traffic, then I started the VM - **this gave me my external IP**
- I tried to curl into the VM and received:
```
curl -v http://34.9.46.253          
*   Trying 34.9.46.253:80...
* connect to 34.9.46.253 port 80 from 192.168.50.160 port 50284 failed: Operation timed out
* Failed to connect to 34.9.46.253 port 80 after 75006 ms: Couldn't connect to server
* Closing connection
curl: (28) Failed to connect to 34.9.46.253 port 80 after 75006 ms: Couldn't connect to server
```
- this lets me know that the packets are timing out instead of being rejected which means a firewall configuration issue or a routing error.
- I checked the active firewall rules and seen: `homework-deny-all        homework-vpc  INGRESS    0                                       all   False
` which shows me that there is a firewall rule blocking my traffic.
- I go to the firewall section and deleted that rule and tried to curl my vm again
- it still hangs.......
- definitely means there is something wrong with the internet routing.
- I run a command to see the compute routes and find:
```
gcloud compute routes list --filter="network:homework-vpc"
NAME                              NETWORK       DEST_RANGE    NEXT_HOP      PRIORITY
default-route-r-c21ae34f7b5f51ec  homework-vpc  10.10.0.0/24  homework-vpc  0
```
- There is no route to the default internet gateway (0.0.0.0/0)
- I go into the console and create a default route for the homework-vpc
- I then went into the firewall rule for `homework-allow-ssh` and seen that it had a slurce IP range of 1.2.3.4/32, I don't know where that is but that is the only address allowed to SSH in so I changed it to 0.0.0.0/0 to allow anyone to SSH into the vm instance.
- now run your final tests:
```
gcloud compute ssh homework-vm --zone=us-central1-a
Warning: Permanently added 'compute.930621164401881092' (ED25519) to the list of known hosts.
Linux homework-vm 6.1.0-47-cloud-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.170-3 (2026-05-08) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
```
- this shows that I am able to SSh into the instance
- I tried to curl again....no dice. So I can ssh into the instance but still cant access it through the internet. That means the engineer completely uninstalled the Nginx application from the linux server...
- to get it reinstalled I first ssh back into the instance then we run the commands:
```
apt update
    apt install -y apache2
    systemctl start apache2
    echo "You fixed the VM! Yay!" | sudo tee /var/www/html/index.html
```
- now our curl works and shows we fixed the VM!