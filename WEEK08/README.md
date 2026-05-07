Week 8 Assignment
GCP & TERRAFORM

Q&A
1.What is the difference between high availability and fault tolerance? Which is best to strive for? 
High availability(HA); refers to a system's ability to remain operational and accessible even when one or more of its components fail. HA is achieved through redundancy and failover mechanism.For instance in a supermarket with multiple checkout cashiers. If one cashier goes on break, there's a short wait, but the other cashiers handle the queue. Shopping continues  just with a small delay. 
Fault tolerance is the capability of a system to continue functioning correctly even in the event of a fault or failure in one or more of its components.Fault tolerance is like having a co-pilot in a plane. If the pilot passes out, the co-pilot grabs the controls immediately and the passengers feel nothing 
The best to strive for depends on the impact or the cost of its downtime.
Ask yourself "What happens if this goes down for 30 seconds?" If the answer is "users get an error" then  HA is fine. If the answer is "someone could die or we lose millions" then you’ll need fault tolerance. 

2.Explain the difference between autoscaling and elasticity. What is vertical and horizontal autoscaling? Is one better? Are they feasible on prem? 
Autoscaling; is the process of automatically and dynamically matching resources to meet the performance requirements of a system. (The tooling that enable elasticity to happen)
Elasticity; is the ability of a system to automatically grow and shrink resources based on demand. Think of it as a balloon when you blow in air it expands and shrinks when the air is let out.
Vertical autoscaling; or scaling up or down, where you increase or decrease computing power thus automatically adjust to the workload demands.
Horizontal scaling;  or scaling out or in, where you add more databases or divide your large database into smaller nodes. Take for instance adding more servers or reducing servers to server the load.


Is one better? Horizontal scaling may be better in that; you can scale to thousands of servers also adding servers doesn’t interrupt users and if one server dies the others keep serving the traffic.

 Are they feasible on prem? 
These solutions are both feasible on prem for smaller sized companies but it's a better option to use cloud based solutions since they can be more cost efficient in that you only pay for what you use and  allow for elasticity which wins in the long run. 

3.Explain what the difference between managed and unmanaged instance groups is.
Managed instance groups (MIGs) let you operate apps on multiple identical VMs. Allowing you make use of automated MIG services, including: autoscaling, autohealing, regional (multiple zone) deployment, and automatic updating.
Unmanaged instance groups let you load balance across a number of VMs that you manage yourself.
4.Explain the different use cases for health checks used by applications (in instance groups) and health checks used by load balancers. Can they be the same? Are they different API calls? Should they be the same? 
A health check is just a regular automated question asked to the server like asking the server “Are you alive and working?”
Now for the instance group the ordeal is “Is the server live enough to keep running, or it should be replaced?”
Load balancers; This is basically on the traffic, the load balancer routes request only to the healthy targets. Think of it as a restaurant host checking which tables are clean and ready before seating a customer. They don't care why a table isn't ready they just need to know if it's ready right now. 


Can they be the same? Yes. They can hit the same Endpoint e.g (
GET /health)
 Are they different API calls?
You can configure them to have same API calls but different independent thresholds.
 Example:
#Same urls.
GET https://my-server/health  ← Load Balancer calls this
GET https://my-server/health  ← Instance Group calls this

# ...but they are configured independently with different thresholds
Load Balancer:    fail after 2 consecutive failures → stop sending traffic
Instance Group:   fail after 10 consecutive failures → kill and replace server

5.Explain in a few sentences what the 3 tier architecture is and how it relates to what you are learning. 
Three-tier architecture is a way of organizing an application into three separate layers, each with a distinct job:
Presentation Tier (Front End) - What the user sees and interacts with. A website, mobile app, or UI.
Application Tier (Back End / Logic) - The brains. Processes requests, runs business logic, makes decisions.
Data Tier (Database) - Stores and retrieves data. Databases, file storage, etc.
Think of it like a restaurant;  the customer interacts with the front of house (presentation), the kitchen processes the order (application), and the pantry holds all the ingredients (data).
Runbook: Managed Instance Group (MIG) Deployment
The Goal: The objective is to deploy self-healing, identical virtual machines that automatically scale based on user demand. By the end of this guide, you will have a resilient application layer that can survive the failure of aphysical data center.
Runbook:
On the top left Click the navigation bar (3 dashes) scroll down to compute engine and click it or Inside of GCP type ‘’Compute Engine’’ in the search bar.
Select Create Instance Template.
Name the template i.e instance-template-20260507-174517.
Locate by scrolling down & select Allow HTTP traffic.
Select the dropdown for Advanced options, Select the dropdown for Mangement, and location the section for Automation(startup script) & paste your script i.e. https://github.com/BalericaAI/SEIR-1/blob/main/weekly_lessons/weeka/userscripts/supera.sh.
Select Create and wait for creation/completion.
Click on VM Instances the click on create VM instance.
You’ll see create from – click it and select the Instance Template you created and wait for it to create a VM.
Next select Instance Groups and Create Instance Group.
Provide a name or use the default name.
Select Instance template and choose your newly created instance template.
Number of instances choose 4.
Location: choose Multiple zones for HA and Fault Tolerance. Choosing multiple zones lets you know that instance groups will be managed across multiple zones the while single zone will only be managed for a single zone.
Autoscaling: Review the instance group you've created and select configure for the Autoscaling(should say not configured). Select Configure Autoscaling + change settings to Minimum number of instances default settings are fine for testing.
Autohealing: Select Health check + Create health check.
Provide a name i.e. my-health-check1
Select Create to create the Instance Group.
Autohealing + health checks with logs enabled allows you to monitor the status of your application beyond just verifying the server is running and assists with troubleshooting as well as replacement of instances.
Verification & Critical Configs:
Multi-Zone Distribution: By selecting "Multiple Zones," you ensure that if us-central1-a goes dark, your application stays alive in us-central1-b and us-central1-c.
The "Pulse" (Health Checks): We use a Health Check with logs enabled so the system can automatically replace "zombie" instances - VMs that are powered on but whose internal application has crashed.
Testing: To verify, you can manually delete one VM from the group; within minutes, the MIG will detect the loss and spin up a replacement automatically.


Terraform
 How to Output VM IP Addresses
 To display the IPs, you use an output block that drills into the network interface attribute of the VM. 

 
References:
https://www.geeksforgeeks.org/system-design/high-availability-vs-fault-tolerance-vs-disaster-recovery/ for high availability and fault tolerance
https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/scaling-out-vs-scaling-up#autoscaling for auto scaling and Elasticity 
https://docs.cloud.google.com/compute/docs/instance-groups#managed_instance_groups used for MIG, HA, Autoscaling, Scalability, Health Checking.

https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html for health checks



