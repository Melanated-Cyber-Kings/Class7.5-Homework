#### Prerequisites
1. Access to Google Cloud Platform (GCP) with a billing account.
2. Permissions to create and manage Compute Engine resources.
3. Compute Engine API enabled in the GCP project.
4. Create VPC network and subnetwork in a specific region (e.g., us-central1).
5. Add or remove firewall rules to allow HTTP/HTTPS traffic on port 80 to the instances in the instance group.
6. A startup script that will be executed on the first VM initialization of each instance.



#### ClickOps Procedure to Create a Global External HTTP(S) Load Balancer with Cloud Armor and Cloud CDN

Workflow:
1. Create a VPC network and subnetwork in the us-central1 region.
2. Create a Managed Instance Group with 3 instances in the us-central1 region, using the latest CentOS 10 image and allowing HTTP traffic on port 80.
3. Create a health check that pings the instances on port 80 every 5 seconds, with a timeout of 5 seconds and a healthy threshold of 2.
4. Create a backend service that uses the health check and adds the instance group as a backend.
5. Create a URL map that routes all traffic to the backend service.
6. Create a target HTTP proxy that uses the URL map.
7. Create a global forwarding rule that points to the target HTTP proxy and uses an anycast IP address.
8. Enable Cloud CDN on the backend service.
9. Create a Cloud Armor security policy with a rule to block traffic from a specific IP address and apply it to the backend service.
10. Create external global HTTP load balancer with the above components and verify that it is working by accessing the anycast IP address in a web browser.

#### VPC Network and Subnetwork Setup
Note: We create a VPC network and subnetwork rather than using the default VPC to ensure that we have an isolated environment to build and deploy these resources.

1. Go to the Google Cloud Console and navigate to VPC network > VPC networks.
2. Click on "Create VPC network".
3. Name the network "mephisto-network".
4. Under "Subnet creation mode", select "Custom".
5. Click "Add subnet".
6. Name the subnet "mephisto-subnet".
7. Select the "us-central1" region and set the IP range to "10.100.0.0/16".
8. Create subnet IP range "10.100.1.0/24" for the instance group.
9. Click "Done" to save the subnet.
10. Click "Create" to create the VPC network and subnet.


#### Managed Instance Group Creation
1. Go to the Google Cloud Console and navigate to Compute Engine > Instance groups.
2. Click on "Create instance group".
3. Name the instance group "mephisto-template-group".
4. Select "Managed instance group".
5. Choose the "us-central1" region and select a zone (e.g., us-central1-a).
6. Under "Instance template", click "Create a new instance template".
7. Name the instance template "mephisto-template".
8. Under "Machine configuration", select "N2" series and choose a machine type (e.g., n2-standard-1).
9. Under "Boot disk", click "Change" and select "CentOS 10" from the list of images. Click "Select".
10. Under "Firewall", check the box for "Allow HTTP traffic".
11. Click "Create" to save the instance template.
12. Back on the instance group creation page, select the newly created instance template "mephisto-template".
13. Set the number of instances to 3.
14. Click "Create" to create the managed instance group.

Note: Health Check is not required since the load balancer will automatically create one when we create the backend service.

#### Backend Service Creation
1. Navigate to Network Services > Load balancing in the Google Cloud Console.
2. Click on "Create load balancer".
3. Select "HTTP(S) Load Balancing" and click "Start configuration".
4. Choose "From Internet to my VMs" and click "Continue".
5. Under "Backend configuration", click "Create a backend service".
6. Name the backend service "mephisto-backend-service".
7. Under "Backends", click "Add backend".
8. Select the instance group "mephisto-template-group" created earlier.
9. Set the port to 80 and click "Done".
10. Under "Health check", click "Create a health check".
11. Name the health check "mephisto-health-check".
12. Set the protocol to "HTTP", port to 80, and configure the check interval to 5 seconds, timeout to 5 seconds, and healthy threshold to 2.
13. Click "Create" to save the health check.
14. Click "Create" to save the backend service.

#### URL Map Creation
1. Under "Host and path rules", click "Create a URL map".
2. Name the URL map "mephisto-url-map".
3. Under "Default route", select the backend service "mephisto-backend-service".
4. Click "Create" to save the URL map. 

#### Target HTTP Proxy Creation
1. Under "Frontend configuration", click "Create a target HTTP proxy".
2. Name the target HTTP proxy "mephisto-http-proxy".
3. Select the URL map "mephisto-url-map" created earlier.
4. Click "Create" to save the target HTTP proxy.    

#### Global Forwarding Rule Creation
1. Under "Frontend configuration", click "Create a forwarding rule".
2. Name the forwarding rule "mephisto-forwarding-rule".
3. Set the IP address to "Create IP address" and name it "mephisto-ip".
4. Set the port to 80 and select the target HTTP proxy "mephisto-http-proxy".
5. Click "Create" to save the forwarding rule.

CDN is not used in this configuration, so we will skip enabling it on the backend service.

#### Cloud Armor Security Policy Creation
1. Navigate to Security > Cloud Armor in the Google Cloud Console.
2. Click on "Create policy".        
3. Name the policy "mephisto-security-policy".
4. Under "Rules", click "Add rule".
5. Name the rule "block-malicious-ip".
6. Set the action to "Deny (403)".
7. Under "Match condition", select "IP address" and enter the specific IP address you want to block  (e.g. 192.168.1.1).
8. Click "Done" to save the rule.
9. Click "Create" to save the security policy.  
10. After creating the policy, click on it to view its details.
11. Under "Applied to", click "Add item".
12. Select "Backend service" and choose "mephisto-backend-service".
13. Click "Save" to apply the security policy to the backend service.   

#### Create External Global HTTP Load Balancer
1. After completing the above steps, review all configurations in the load balancer setup.
2. Click "Create" to finalize the creation of the global external HTTP load balancer with Cloud Armor and Cloud CDN.
3. Once the load balancer is created, note the anycast IP address assigned to the forwarding rule.
4. Open a web browser and navigate to the anycast IP address to verify that the load balancer is working correctly and serving traffic from the backend instances.

#### Verification
1. Open a web browser and navigate to the anycast IP address assigned to the forwarding rule.
2. You should see the default page served by the backend instances, confirming that the load balancer is correctly routing traffic to the instance group.

#### Cleanup
Workflow: We work in reverse order to ensure dependencies are properly handled when deleting resources.

1. Navigate to Network Services > Load balancing in the Google Cloud Console.
2. Click on the load balancer you created (e.g., "mephisto-load-balancer").
3. Click "Delete" to remove the load balancer and all associated components (forwarding rule, target proxy, URL map, backend service).
4. Navigate to Security > Cloud Armor in the Google Cloud Console.
5. Click on the security policy you created (e.g., "mephisto-security-policy").
6. Click "Delete" to remove the Cloud Armor security policy.
7. Navigate to Compute Engine > Instance groups in the Google Cloud Console.
8. Click on the managed instance group you created (e.g., "mephisto-template-group").
9. Click "Delete" to remove the instance group and all associated instances.
10. Navigate to VPC network > VPC networks in the Google Cloud Console.
11. Click on the VPC network you created (e.g., "mephisto-network").
12. Click "Delete" to remove the VPC network and all associated subnets.    

Note: Be sure to confirm the deletion of each resource after clicking "Delete" to ensure that all resources are properly removed from your GCP project.

