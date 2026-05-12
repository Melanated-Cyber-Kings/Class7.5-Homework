<details>
<summary>Q & A</summary>

## 1. What is the difference between high availability and fault tolerance? Which is best to strive for?

  High availability (HA) is the practice of designing systems so applications remain operational even if individual components fail. This is commonly achieved using multiple VM instances, managed instance groups, regional deployments, and load balancers.

  Fault tolerance is where systems continue functioning with little or no interruption during failures. Fault-tolerant systems use real-time replication, redundant infrastructure, and distributed services across multiple zones or regions.

  Most organizations aim for high availability because it provides strong reliability while remaining cost-effective and manageable. Full fault tolerance is reserved for mission-critical systems when it's unacceptable due to financial, operational, or safety concerns.

  ### GCP Resources
  - Google Cloud Reliability Guide  
    https://cloud.google.com/architecture/framework/reliability

  - Regions and Zones Overview  
    https://cloud.google.com/compute/docs/regions-zones

  - Designing Highly Available Systems on GCP  
    https://cloud.google.com/architecture/infra-reliability-guide

---

## 2. Explain the difference between autoscaling and elasticity. What is vertical and horizontal autoscaling? Is one better? Are they feasible on prem?

  Autoscaling is the automatic adjustment of computing resources based on workload demand. Managed instance groups can automatically add or remove VM instances depending on metrics such as CPU utilization, load balancer capacity, or custom monitoring metrics.

  Elasticity is a system’s ability to dynamically grow or shrink resources as things change.

  ### Vertical Scaling
  Vertical scaling means increasing the resources of a single VM.

  Example:
  - Increasing a VM from 2 vCPUs to 8 vCPUs
  - Increasing memory from 8 GB RAM to 32 GB RAM

  Advantages:
  - Simple application architecture
  - Easier for legacy applications

  Disadvantages:
  - Hardware limits
  - Requires downtime
  - Single point of failure

  ### Horizontal Scaling
  Horizontal scaling means adding additional VM instances to distribute workloads across different systems.

  Example:
  - Going from 2 web servers to 10 web servers in a M.I.G. with a load balancer

  Advantages:
  - Better redundancy and availability
  - Cloud-native applications
  - Scale large workloads

  Disadvantages:
  - Complex application design

  Horizontal scaling is preferred in cloud environments because it improves scalability, resiliency, and availability. Some environments use both vertical and horizontal scaling.

  Both methods are feasible on-premises, but cloud platforms like GCP simplify autoscaling significantly because infrastructure can be provisioned automatically without purchasing or installing hardware manually.

  ### GCP Resources
  - GCP Autoscaler Documentation  
    https://cloud.google.com/compute/docs/autoscaler

  - Autoscaling Managed Instance Groups  
    https://cloud.google.com/compute/docs/autoscaler/scaling-managed-instance-groups

  - Scaling Concepts in Compute Engine  
    https://cloud.google.com/compute/docs/instance-groups

---

## 3. Explain what the difference between managed and unmanaged instance groups is.

  An instance group is a collection of virtual machine instances managed together as a single logical resource.

  ### Managed Instance Groups (MIGs)

  Managed instance groups (M.I.G.) automatically create, maintain, repair, and scale VM instances using an instance template. GCP keeps your number of VM instances running.

  Features include:
  - Autoscaling
  - Autohealing
  - Automatic recreation of failed VMs
  - Load balancer

  Example:
  - If a VM crashes or fails health checks, GCP automatically recreates it.

  Managed instance groups are commonly used for:
  - Web applications
  - Stateless services
  - Auto-Updates
  - Highly available systems

  ### Unmanaged Instance Groups

  Unmanaged instance groups are manually managed collections of VMs. GCP does not automatically create, repair, or scale these instances.

  Features:
  - No autoscaling
  - No autohealing
  - No updates
  - Manual VM management

  Unmanaged instance groups are used when:
  - VMs require unique configurations
  - Applications are legacy-based
  - Administrators need full manual control

  In modern cloud architecture, managed instance groups are preferred because they automate tasks and improve reliability.

  ### GCP Resources
  - Managed Instance Groups Overview  
    https://cloud.google.com/compute/docs/instance-groups

  - Instance Templates  
    https://cloud.google.com/compute/docs/instance-templates

  - Autohealing in MIGs  
    https://cloud.google.com/compute/docs/instance-groups/autohealing-instances-in-migs

---

## 4. Explain the different use cases for health checks used by applications (in instance groups) and health checks used by load balancers. Can they be the same? Are they different API calls? Should they be the same?

  Health checks are automated tests used to determine if applications and infrastructure components are functioning properly.

  ### Health Checks for Managed Instance Groups

  In GCP managed instance groups, health checks are used for autohealing. If a VM becomes unhealthy, GCP can automatically recreate the instance.

  Example:
  - A web server stops responding
  - The health check fails repeatedly
  - The managed instance group recreates the VM automatically

  ### Health Checks for Load Balancers

  Load balancer health checks configure where traffic should be qhen routed to a backend VM instance.

  Example:
  - A backend application starts returning errors
  - The load balancer marks it unhealthy
  - Traffic is redirected to healthy backend instances only

  ### Can They Be the Same?

  Yes. Both systems can use the same endpoint such as:
  - `/health`
  - `/status`
  - `/ready`

  - MIG health checks decide whether to repair a VM
  - Load balancer health checks decide whether traffic should be routed to a VM

  ### Should They Be the Same?

  They should be the same so both systems have a common definition of “healthy.”

  ### GCP Resources
  - GCP Health Checks Documentation  
    https://cloud.google.com/load-balancing/docs/health-checks

  - Autohealing Policies for MIGs  
    https://cloud.google.com/compute/docs/instance-groups/autohealing-instances-in-migs

  - Backend Services and Health Checks  
    https://cloud.google.com/load-balancing/docs/backend-service

---

## 5. Explain in a few sentences what the 3 tier architecture is and how it relates to what you are learning.

  Three-tier architecture is a common application design model that separates an application into three independent layers. This separation improves scalability, security, reliability, and maintainability.

  ### A. Presentation Tier
  The frontend layer users interact with.

  Examples:
  - Web browsers
  - Web frontends
  - ATM

  ### B. Application Tier
  The backend layer where business logic and processing occur.

  Examples:
  - APIs
  - Application servers
  - Authentication services

  ### C. Data Tier
  The database and storage layer where persistent data is stored.

  Examples:
  - Cloud SQL
  - Databases
  - Persistent storage systems

  This architecture directly relates to GCP because many cloud deployments separate these layers across different services and infrastructure components.

  Example GCP deployment:
  - Cloud Load Balancer and frontend VMs for the presentation tier
  - Managed instance groups for the application tier
  - Cloud SQL for the data tier

  ### GCP Resources
  - Google Cloud Architecture Framework  
    https://cloud.google.com/architecture/framework

  - GCP Load Balancing Overview  
    https://cloud.google.com/load-balancing/docs/load-balancing-overview

  - Cloud SQL Documentation  
    https://cloud.google.com/sql/docs

  - GCP Three-Tier Web App Example  
    https://cloud.google.com/architecture/three-tier-web-app

</details>

<details>
<summary>RunBook</summary>

## End Goal
Provision a production-ready **Managed Instance Group (MIG)** in Google Cloud Platform using the Console (ClickOps).  
The MIG must be **multi-zone, autohealing-enabled, and autoscaling-capable**, and ready to serve traffic behind a load balancer.  
Oncw completed...maintain, scale, and replace instances on refresh.

<details>
<summary>Prerequisites</summary>

Before starting, ensure the following are already in place:

- A **GCP Project** with billing enabled and Compute Engine API enabled
- A **custom or base VM instance template** prepared:
  - OS selected (e.g., Debian, Ubuntu, or custom image)
  - Startup script
  - Required firewall tags applied (e.g., `allow-all`, `firewall`)
- A defined **VPC network and subnet(s)** in the target region
- At least **3+ zones available in the chosen region**
- Application health endpoint available (e.g., `/health`)
- Optional but recommended:
  - Load balancer backend service already planned or created

---

## 🧱 Step 1: Create the Managed Instance Group (MIG)

1. Navigate to:  
   **Compute Engine → Instance groups → Create instance group**

2. Select:
   - **Type:** Managed instance group
   - **Location:** Zonal or Regional  
     > ⚠️ Use **Regional MIG** for multi-zone deployment (recommended for HA)

3. Configure:
   - **Instance template:** Select pre-created template (e.g., `supera`)
   - **Region:** Choose target region (e.g., `us-central1`)
   - **Zones:** Ensure multiple zones are selected (e.g., `us-central1-a`, `b`, `c`)

---

## 🌍 Step 2: Verify Multi-Zone Distribution

After creation:

1. Open MIG → **Instance tab**
2. Confirm instances are distributed across zones:
3. Validate:
   - Zone column shows multiple zones
   - MIG type is **REGIONAL (not zonal)**

> If instances are not distributed:
- Confirm MIG type = Regional

---

## 📈 Step 3: Enable Autoscaling

1. Open MIG → **Edit → Autoscaling section**

2. Enable autoscaling:
   - Toggle: **ON**

3. Configure scaling policy:
   - **Metric:** CPU utilization

4. Set scaling bounds:
   - **Minimum instances:** e.g., 2
   - **Maximum instances:** e.g., 10–20 (based on workload expectations)

5. Save configuration

---

## ❤️ Step 4: Enable Autohealing

1. Open MIG → **Autohealing section**

2. Create or attach a **Health Check**:
   - Protocol: HTTP / TCP depending on app
   - Request path: `/health`
   - Port: application port (e.g., 80, 443)

3. Configure:
   - **Initial delay:** 60–300 seconds (depends on boot time)
     > Prevents premature healing during VM startup

4. Attach health check to MIG autohealing policy

---

## 🧠 Outcome

At completion, the system should behave as a self-healing, self-scaling compute layer that:
- Automatically replaces failed instances
- Scales based on demand
- Survives zonal failures
- Serves traffic reliably behind a load balancer

---

# Terraform

---

## 🧱 Mandatory (Required) Arguments for a GCP VM (`google_compute_instance`)

When creating a VM in Terraform for Google Cloud, there are a few **required arguments** you must provide in order for the resource to be valid.

### Required arguments:

- **`name`**
  - The unique name of the VM instance.
  - Must be unique within the project and zone.
  - This is how you reference the VM in GCP and Terraform.

- **`machine_type`**
  - Defines the compute resources (CPU/RAM) of the VM.
  - Example: `e2-medium`, `n2-standard-2`.
  - Determines performance and cost.

- **`zone`**
  - Specifies the zone where the VM will be deployed.
  - Example: `us-central1-a`.
  - Required because Compute Engine VMs are zonal resources.

- **`boot_disk`**
  - Defines the operating system disk for the VM.
  - Must include:
    - Image OR image family
    - Disk configuration (size/type if customized)
  - Without this, the VM has nothing to boot from.

- **`network_interface`**
  - Defines networking configuration.
  - Typically includes:
    - VPC network
    - Subnetwork
    - Optional external IP configuration

---

## 📤 Output Internal and External IP Addresses

You can output both internal and external IPs using Terraform outputs after the VM is created.

### Example:

```hcl
output "internal_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}

output "external_ip" {
  value = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

</details>
</details>