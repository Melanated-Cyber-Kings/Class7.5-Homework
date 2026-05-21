Unavailable Service RUNBOOK:
1. Informed that a "drunk engineer" attempted to make changes to the environment but in the process, broke several things.
Initial problem statement is that the Virtual Machine (VM) is not accessible as a web server via its public IP address. also, SSH access to the VM is not working.

2. Accessed GCP console to get an understanding of the architecture and what services were associated with the VM.

3. Started the VM as it was not powered stopped. 

4. Added external IP address to the VM as it only had a private IP address.

5. Deleted the deny all firewall rule that was blocking all ingress traffic to the VM.

6. Added the http-server tag to the VM to allow HTTP traffic.

7. Adjusted SSH source IP rule from client range to 

Added default gateway to the VPC 
```bash
gcloud compute routes create default-internet-route --network=homework-vpc --destination-range=0.0.0.0/0 --next-hop-gateway=default-internet-gateway
```

8. Ran ping commands 8.8.8.8

9. Ran commands to install apache server, started apache server and added content to index.html
```bash
 apt update
    apt install -y apache2
    systemctl start apache2
    echo "You fixed the VM! Yay!" > /var/www/html/index.html
```
