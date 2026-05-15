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

