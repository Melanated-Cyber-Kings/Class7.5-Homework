**What is the difference between high availability and fault tolerance? Which is best to strive for?**

High availability is to keep the services accessible with minimal downtime, a fast recovery due to a quick failover.
Fault tolerance is to keep the services running without interruption when a failure occurs.

**Explain the difference between autoscaling and elasticity. What is vertical and horizontal autoscaling? Is one better? Are they feasible on prem?**

Autoscaling is the automation of the adjustement for ressources that follows previously defined properties.
Elasticity is the system ability to efficiently scale those ressources up and down.

Vertical scaling upgrades a single machine of its CPU, RAM, and storage.
Horizontal scaling is when you add more machines to a system or a cluster to distribute the load.

Horizontal scaling is better, cheaper and give access to more ressources.

**Explain what the difference between managed and unmanaged instance groups is.**
A managed instance group (MIG) creates each of its managed instances based on the configuration components that you use: 
instance template, optional all-instances configuration, and optional stateful configuration

An Unmanaged Instance Group (UMIG) is a logical grouping of virtual machines in GCP where each VM is managed individually

Unlike Managed Instance Groups (MIGs), UMIGs do not require all VMs to be identical and do not provide automated services like autoscaling or auto-healing

**Explain the different use cases for health checks used by applications (in instance groups) and health checks used by load balancers. Can they be the same? Are they different API calls? Should they be the same?**

Health check use by MIG can be inherited and they are created for a region. Health checks for LB are created aither for a region or globally.

yes they can be the same. They use the same API healthChecks.get, healthChecks.list.
It depends of the use cases. 
If your services is deployed across multiple regions the healthchecks are different.
They are the same within the same region.

**Explain in a few sentences what the 3 tier architecture is and how it relates to what you are learning.**

The user interface tier, the application (where the data is processed) and the data tier (where the data is stored and managed) are the components of the 3 tier architecture.