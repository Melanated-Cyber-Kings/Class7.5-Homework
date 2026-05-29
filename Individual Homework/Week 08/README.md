# Week 8 Homework - GCP Compute

## Q&A
### Q1 - **What is the difference between high availability and fault tolerance? Which is best to strive for?**
**High Availability (HA)** means designing systems to *minimise downtime* by quickly recovering when something fails, often with a small interruption.  

**Fault Tolerance (FT)** means designing systems for *zero downtime*, where failures cause no disruption at all.  

The key difference is that HA allows brief outages, while FT provides continuous operation without interruption but FT is significantly more complex and expensive and is used only when zero data loss and zero interruption are legally or financially mandatory.

It is best to strive for what serves the business needs. In practice, most organisations aim for **high availability**, as it balances reliability, cost, and complexity effectively.

### Q2 - **Explain the difference between autoscaling and elasticity. What is vertical and horizontal autoscaling? Is one better? Are they feasible on prem?**
**Elasticity** is the overall ability to dynamically adjust resources, while **Autoscaling** is the mechanism that makes elasticity happen. 

**Vertical scaling** adds power to a single server (scale up), whereas **Horizontal scaling** adds more servers (scale out). 

Horizontal scaling is generally better for modern cloud apps because it offers virtually unlimited growth and fault tolerance, though vertical scaling remains a more simple solution for small or stateful workloads.

Both approaches are feasible on-premises, but true elasticity is limited by long hardware procurement times, forcing most on-prem organisations to over-allocate instead.

Cloud engineers prioritise horizontal autoscaling for stateless services and reserve vertical scaling for legacy systems or databases that aren’t yet ready to distribute data.

### Q3 - **Explain what the difference between managed and unmanaged instance groups is.**
**Managed Instance Groups (MIG)** automatically create, scale, and heal virtual machines based on a defined template, making them ideal for production workloads.  

**Unmanaged instance groups** require you to manually create, manage, and maintain each virtual machine.  

The key difference is that managed groups provide automation and consistency, while unmanaged groups offer full manual control.  

Managed instance groups support autoscaling, load balancing, and high availability, whereas unmanaged groups do not.  

In practice, managed instance groups are the preferred choice for most modern cloud architectures, unmanaged instance groups are used for legacy systems and testing/forensics.

### Q4 - **Explain the different use cases for health checks used by applications (in instance groups) and health checks used by load balancers. Can they be the same? Are they different API calls? Should they be the same?**
**Application health checks** used by instance groups determine *whether a virtual machine should be repaired or replaced*, while **load balancer health checks** decide *whether traffic should be sent to that machine*.  

The key difference is that instance group health checks trigger *autohealing* actions, whereas load balancer health checks only affect *traffic routing*.  

Although they can technically use the same endpoint, they are configured as separate resources and serve different purposes.  

Using the same health check for both can lead to unnecessary VM restarts, instability and cascading failures.

Best practice is to use separate health check endpoints, with stricter checks for load balancing and more tolerant checks for autohealing.

### Q5 - **Explain in a few sentences what the 3 tier architecture is and how it relates to what you are learning.**
**Three-tier architecture** separates an application into **presentation** (web frontend), **application** (business logic), and **data** (database) tiers that run on independent infrastructure. 

This separation allows each tier to scale differently. Presentation and application tiers scale horizontally with MIGs, while the data tier typically scales vertically. 

The concepts previously discussed map directly: health checks become more thorough as you go down the tiers, and load balancers sit between the user and presentation tier and again between presentation and application tiers.

MIGs work for the stateless presentation and application tiers, but the stateful data tier often uses managed database services instead of generic instance groups. 

Understanding 3-tier architecture gives you a mental framework for deciding where to apply horizontal scaling, auto-healing, and different health check strategies based on each tier's unique failure modes and scaling requirements.

---

## Runbook: Managed Instance Group Deployment (via Clickops)

### End Goal
Deploy a Managed Instance Group (MIG) of identical VMs distributed across multiple zones in the `europe-west2 (London)` region. This will be done with autoscaling (3-10 instances) and auto-healing.

### Prerequisites
- An active Google Cloud Platform (GCP) account.
- Compute Engine API enabled
- An existing Instance Template (with a working startup script and `http-server` tag)
- `gcloud auth application-default-login` already run

### Procedure

#### 1. Start the MIG creation flow
- Go to **Compute Engine** then **Instance Groups**
- Click **Create Instance Group**

#### 2. Basic Configuration
- **Name**: `week8-hw-mig` (or your preferred name)
- **Description**: Same as name
- **Instance template**: select the instance template you prepared
- **Location**: **Multiple zones**
- **Region**: `europe-west2`
- **Zone selection**: check **all 3 zones** (`europe-west2-c,b,a)
- **Number of instances**: leave this – it will be controlled by autoscaling (set below)

#### 3. Configure Auto-scaling
- Click **Configure autoscaling**
- Toggle **Autoscaling ON**
- **Minimum number of instances**: 3
- **Maximum number of instances**: 10
- **Autoscaling signals**: keep default (CPU utilisation)

#### 4. Configure Auto-healing
- Scroll to the **VM instance lifecycle** section and go to **Auto‑healing**
- Click **Health check**, then **Create a health check**
    - **Name**: `week8-hw-hc` (or your preferred name)
    - **Port**: 80
    - **Scope**: **Regional** (choose `europe-west2`)
    - **Logs**: ON (optional but recommended)
    - Keep default health criteria
- Click **Save**
- **Initial delay**: leave as `300` seconds (allows VMs to fully boot)

#### 5. Complete Creation
- Leave all other settings at defaults
- Click **Create**

### Verification
#### Check for multi-zone distribution
After creation, open the instance group. VMs should be spread across `a`,`b`,`c`.

#### Auto-scaling is active
Instance group page status shows "3 instances". Also Auto-scaling 'On (min 3, max 10)'

#### Auto-healing is active
The Health check column should show health-check name. After a few minutes, all VMs become **healthy (green)**.
![MIG Verification](./Screenshots/06_runbook_mig_verification.png)

#### Optional: Verify auto-healing
1. From the instance group's **Instances** tab, delete any one VM
2. Wait 2‑3 minutes
3. Refresh the page – a new VM will appear, and its health status will become green


In the example below, I deleted the VM ending in “5rkd.” As the VM was being deleted, a new VM ending in “0txd” was automatically created and began booting up.
![VM Delete to New VM](./Screenshots/07_runbook_delete_instance_new_instance.png)

---
## Terraform

### Mandatory (Required) Arguments for a Google Compute Engine VM
The following arguments must be defined in a `google_comute_instance` resource for Terraform to successfully create a VM:

`name` - Give this resource a unique name as GCE needs one. If you change the name later, the old resource will be deleted and a new one will take its place.

`machine_type` - This is where you pick your hardware 'size' (vCPUs and RAM), like an `n2-standard-2`. The machine family (N2, N1, E2) is what decides how fast your setup runs and how much it’ll cost you.

`boot_disk` - This block sets up your main hard drive. At the very least, you’ll need to use `initialize_params` to tell the system which 'image' to use, basically, which OS (like Debian or Ubuntu) you want pre-installed.

`network_interface` - This block that connects the VM to a VPC network. Without it, the VM cannot communicate with other resources or the internet. To get a public IP, make sure to add that `access_config` section (even if empty).

`zone` - Defines which GCP zone (e.g., `us-central1-a`) the VM will run in. Even though `zone` is technically optional, it is a best practice to always include the `zone` argument directly in the VM resource. If it is not provided, the provider zone is used.

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance



### Outputting Internal and External IP Addresses

**Internal IP**

```bash
output "internal_ip" {
  value = google_compute_instance.vm_name.network_interface[0].network_ip
}
```

Your VM's main network card always gets its own internal IP address. The subnet just automatically hands one out as soon as the VM is made.
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#network_ip-1

**External IP**
`google_compute_instance.vm_name.network_interface[0].access_config[0].nat_ip`
```bash
output "external_ip" {
  value = google_compute_instance.vm_name.network_interface[0].access_config[0].nat_ip
}
```  

The `access_config` block is basically a middleman that maps your VM to a public IP. Whether that IP is a temporary one (ephemeral) or one you've kept on reserve (static), this is the bit that links them together.
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#nat_ip-1



### Two Non-Required Arguments explained

`metadata_startup_script`

This argument allows you to insert a shell script that runs automatically the first time a VM boots.

`allow_stopping_for_update`

When set to `true`, Terraform is allowed to stop the VM in order to modify certain fields that cannot be changed while the VM is running (e.g., `machine_type`).
Without this argument, changing a field like `machine_type` forces Terraform to destroy and recreate the VM. When set to `true`, Terraform stops, modifies, then restarts the VM.
This is used when you have stateful VMs that you can't easily tear down and rebuild.



### Finding the Correct Image format for CentOS Stream 10
I consulted the official [Google Cloud Compute Engine OS Images documentation](https://cloud.google.com/compute/docs/images), which states that public OS images are organized into projects and families, and that CentOS images are available in the `centos-cloud` project.

Second, I ran `gcloud compute images list --project centos-cloud --no-standard-images` in my terminal. The output showed image names like `centos-stream-10-v20250415` and confirmed the family name `centos-stream-10`.
![Cent-os_search](./Screenshots/08_tf_centos-cloud_search.png)

Alternatively, I could go to the GCP console and go to the Compute Engine → Storage → Images section.
![Cent-os_search2](./Screenshots/12_tf_centos-cloud_search2.png)

### Difference Between `name`, `id` and `self_link`

- `name` - **what you call it**
- `id` - **Terraform’s tracking ID**
- `self_link` - **GCP’s API address**

The `name` argument is a user-defined value that specifies the actual name of the virtual machine in Google Cloud.  
The `id` is a computed attribute generated by Terraform to uniquely identify and track the resource internally.  
The `self_link` is a computed attribute that provides the full API URL of the resource in Google Cloud.  
You define `name` in your configuration, while `id` and `self_link` are automatically populated after the resource is created.  
In practice, `self_link` is commonly used when referencing resources in other configurations, while `id` is mainly used internally by Terraform.
