 # Week 8
<br/>
<br/>

## 1) Q&A Section (Answer in 1-5 sentences) <br/>

* **What is the difference between high availability and fault tolerance? Which is best to strive for?**
<br/>

        MY ANSWER: High Availability allows for quick recovery for different systems, Fault Tolerance allows for no downtime at all. High Availability should be used for businesses such as IT services, while Fault Tolerance would be suited for Healthcare Databases for that they could access patient information 24/7. The best one a company should strive for is Fault Tolerance, so that they would never had downtime for their systems and patient data accessibility.
<br/>

* **Explain the difference between autoscaling and elasticity. What is vertical and horizontal autoscaling? Is one better? Are they feasible on prem?**
<br/>

        MY ANSWER: The difference between autoscaling and elasticity is that autoscaling adds more VM instances when the demand is called for, and the elasticity can add more VM instances, and also remove VM instances when there is no demand for them anymore.
<br/>

        MY SECOND ANSWER: Vertical scaling increases the size of a VM instance such as adding more RAM, CPU power, and more storage. Horizontal scaling scales out by adding more instances to give the user more RAM, CPU power, and more storage. I would rather choose horizontal scaling, because vertical scaling would continue to scale up to more expensive hardware and the cost wouldn't be feasible anymore. 
<br/>

        MY THIRD ANSWER: I think horizontal scaling would be better for on-premises work, because you can add more VM instances, use load balancers to balance user requests. It is also better because if one server goes out, the rest of the VM instances can keep the application(s) running. 

* **Explain what the difference between managed and unmanaged instance groups is.**
<br/>

        MY ANSWER: Managed instance groups builds similar VM machines using an Instance Template in GCP, or the AWS console, introducing automated scaling, health checks, and load balancing. Unmanaged instance groups builds VM machines of different families, such a E2, C4, N$, and etc.
<br/> 

* **Explain the different use cases for health checks used by applications (in instance groups) and health checks used by load balancers. Can they be the same? Are they different API calls? Should they be the same?**
<br/>

        MY ANSWER: Health checks for instance groups monitors the VM instance availability by sending health check probes from certain ports at certain times like 300 seconds, or 60s, and etc. If that VM instances fails multiple checks, GCP deems that VM instance as unhealthy, routes the traffic away from it and then tries to fix it. Health checks sent by Load Balancers could be the same, but are sent from different services.
<br/>

* **Explain in a few sentences what the 3 tier architecture is and how it relates to what you are learning.** 
<br/>

        MY ANSWER: A three-tier architecture addresses the scalability, the availability, and security of your cloud application for clients. It addresses the availability by deploying multiple instances into multiple AZs of your choice, it addresses the scalability by either scaling your instances horizontially or veritcally for your needs, and it addresses the security by using different ports, security groups on machines or by using different services provided by your cloud-based application. 
<br/>

## 2) Runbook

* **In the first few sentences (3 max) explain the end goal.** 
<br/>

        We're going to create a managed Instance Group on Google Cloud Platform. 

* **Add a section on prerequisites (what do I, as an engineer, need to have ready to make this happen?)**
<br/>

PREREQUISITES:
          * Google Cloud Platform account
          * Instance Template
<br/>

 **Explain how to enable autoscaling and autohealing**
<br/>

"Enabling Autoscaling"
<br/>

1) Open Google Cloud Console
2) Click on Compute Engine
3) Click on Instance Groups
4) Create Instance Groups, select "New managed instance group (stateless)"
5) Choose Name*, Instance Template*, Number of instances*, Location*
6) Click on Configure Autoscaling, set Autoscaling mode to ON, add and remove instances to the group.
7) Choose your Minimum and Maximum number of instances.
8) Choose Autoscaling signals (CPU utilization, HTTP load balancing utilization, Cloud Pub/Sub queue, or Cloud Monitoring metric)
9) Then, set the Target utilization!
<br/>

"Enabling Autohealing"
<br/>

1) While creating your Managed Instance Group, scroll down to VM Instance Lifecycle and select "Create a health check".
2) Give it a Name*, choose Global or Regional, specify Protocol* and Port*, and choose the Health Criteria regarding Check Interval*, Timeout*, Healthy threshold*, and Unhealthy threshold*.
3) Save your health check! 


* **Explain how to verify that the instance group will manage instances across multiple zones**
<br/>

        MY ANSWER: 

* **Explain any other critical config explicitly**
<br/>

        MY ANSWER: 

* **Remember this is for other engineers so no need to try to explain everything like I am a nontechnical person. Also keep in mind runbooks are not for learning but for executing something properly.  Keep it pretty high level. Use whatever amount of detail you feel is correct.**
<br/>

        MY ANSWER: 

* Test it by having a group mate use this runbook to accomplish the goal. They should be able to rely on it only to spin up a properly configured instance group.
<br/>
<br/>

## 3) Terraform

* **Explain the mandatory (required) arguments for a VM in terraform**
<br/>

        MY ANSWER: 

* **Explain how to output the internal and external IP addresses of the provisioned VM and how you figured this out**
<br/>

        MY ANSWER: 

* **Choose 2 non-required arguments and give an explanation for both (do not copy and paste the reference material)**
<br/>

        MY ANSWER: 

* **Explain how you would figure out the correct format for creating a VM with the “centOS stream 10” image (the specific image is up to you).**
<br/>

        MY ANSWER: 

* **Explain the difference between the “name” argument and the computed “id” and “self_link” attributes**
<br/>

        MY ANSWER:
