# Google Cloud Platform & Terraform

This assignment focuses on foundational concepts with an emphasis on services offered by Google Cloud Platform (GCP).

---

## Questions & Answers

### What is the difference between high availability and fault tolerance?

#### High Availability (HA)

High Availability means designing systems so they stay available most of the time, even when something fails. The goal is to minimize downtime.

To achieve HA, you typically use redundancy, such as running multiple systems across multiple zones. If one system fails, another one can take over.

In a typical HA setup:

- One system is usually active, and the others are on hot standby
- If the active system fails, a standby system takes over
- There may be short interruptions during the failover process

Example: If a VM running a web server crashes, another VM in a different zone takes over within seconds or minutes. Users may notice a brief delay, but the service recovers quickly.

#### Fault Tolerance (FT)

Fault Tolerance means designing systems so they experience zero interruption, even during failures. The system continues running without users noticing any loss of service.

To achieve FT:

- You run duplicate systems at the same time
- Both systems process the same data in parallel
- If one fails, the other continues instantly

Cons of FT:

- Much more expensive
- Requires more complex architecture
- Used only for mission‑critical systems (e.g., medical, financial trading, emergency services)

Example: Two servers in different zones run the same application simultaneously. If Zone 1 goes offline, the server in Zone 3 continues instantly with no downtime.

---

### Which is best to strive for?

It depends on the business and the application.

High Availability is the most common choice because it is:

- More affordable
- Easier to implement
- Acceptable for systems where a small amount of downtime is okay

Fault Tolerance is used only when any downtime is unacceptable, such as:

- Life‑critical systems
- Real‑time financial systems
- Emergency response systems

The downside of FT is cost — you are running twice the number of systems, twice the infrastructure, and twice the maintenance.

---

### Explain the difference between autoscaling and elasticity.

#### Autoscaling

Autoscaling is the mechanism that automatically adds or removes virtual machines (or containers) based on how much work your service is handling. For example, a streaming platform might spin up extra servers when a new episode drops and millions of users press “Play,” then scale back down once traffic returns to normal.

#### Elasticity

Elasticity is the broader capability of a system to adjust its resources up or down in near real‑time as workload changes. It ensures the system always has the right amount of capacity without manual intervention. Autoscaling is one of the main techniques used to achieve elasticity.

---

### What is vertical and horizontal autoscaling?

#### Horizontal Autoscaling (Scale Out / Scale In)

Horizontal scaling adds or removes entire VMs.

- Add more VMs/containers when load increases
- Remove them when load decreases

Example: A website normally runs on 3 web servers but scales out to 8 during peak hours.

This is the most common and scalable approach in modern cloud environments.

#### Vertical Autoscaling (Scale Up / Scale Down)

You make a single instance bigger or smaller.

- Add more vCPUs, RAM, or storage to an existing VM

Example: Upgrading a VM from 4 vCPUs to 8 vCPUs to increase processing capacity.

This is simpler but limited by the maximum size of a single machine.

---

### Is one better?

Horizontal scaling is generally the stronger approach because it avoids single points of failure, supports high availability, scales much more effectively, and fits naturally with distributed, stateless architectures. Vertical scaling is simpler to implement, but it often requires downtime, is limited by the maximum size of a single machine, and concentrates risk by relying on one increasingly large server.

---

### Are they feasible on‑premise?

Autoscaling and elasticity are possible on‑prem, but they’re limited by the hardware you already own, slower provisioning, and less automation. Cloud platforms generally handle scaling more efficiently and cost‑effectively, making them the better long‑term option for true elasticity.

---

### Explain what the difference between managed and unmanaged instance groups is.

A managed instance group (MIG) automatically handles things like creating VMs, patching, autoscaling, auto‑healing, and even deploying across regions. MIGs use instance templates to ensure every VM is identical, which makes scaling and recovery consistent and predictable.

An unmanaged instance group is just a set of VMs that you manage yourself. There’s no automatic healing, scaling, or patching, and each VM can be configured differently if you want. The user is responsible for all operations and maintenance tasks.

Managed instance groups are best for stateless, scalable workloads, while unmanaged groups would be an alternative when you need full control or when your VMs are too customized to fit into a single template.

---

### Explain the different use cases for health checks used by applications (in instance groups) and health checks used by load balancers. Can they be the same? Are they different API calls? Should they be the same?

Health checks are basically a way to confirm whether a service is reachable and functioning. In an instance group, health checks are used to determine if a VM is healthy enough to stay in the group; if it fails, the MIG may repair or replace that VM. Load balancer health checks focus on whether the application on that VM is ready to handle traffic, and if the check fails, the load balancer simply stops sending requests to it.

MIGs and load balancers can use the same endpoint, but they don’t have to, and they use different API calls. It’s generally best to keep them separate so an application‑level issue doesn’t accidentally trigger a full VM replacement.

---

### Explain in a few sentences what the 3‑tier architecture is and how it relates to what you are learning.

A 3‑tier architecture is basically a layered approach that splits services into three logical tiers. These tiers are:

- Presentation tier / front‑end (the user interface)
- Application tier / middle tier (the application or business logic)
- Data tier / backend (the database)

Each tier has its own role, which makes the system easier to scale, secure, and maintain.

This relates to what I’m learning because many cloud best practices like separation of responsibilities, controlling data exchanges between tiers, and resource management are built around this model. Understanding the 3‑tier structure is important from a security‑focused architecture mindset, especially when planning and managing the lifecycle of critical services.

---

## RUNBOOK

The goal is to provide a fully configured managed instance group on GCP with a standard compute engine and startup script. The MIG will have autoscaling, autohealing, and multi-zone enabled. Engineers should be able to use this runbook without additional documentation to create a fully functional MIG.

---

### Prerequisites

- Access to Google Cloud Platform (GCP) with a billing account
- Permissions to create and manage Compute Engine resources
- Compute Engine API enabled in the GCP project
- Default VPC and infrastructure set up in the GCP project
- A startup script that will be executed on the first VM initialization of each instance

This runbook provides two versions of the startup script:

- One for Ubuntu-based operating systems  
  Name: `startup-ubuntu.sh`
- One for Red Hat-based operating systems  
  Name: `startup-redhat.sh`

Select the script that matches the operating system selected for the VM’s boot disk.

---

### Steps to Create a Managed Instance Group (MIG)

#### 1. Create an Instance Template

- Go to the GCP Console.
- In the GCP console, go to **Compute Engine → Instance templates**.
- Click **Create instance template**.

Fill in the required fields:

- Name: `demo-mig-instance-template`
- Machine type: Choose an appropriate machine type (e.g., `n2-standard-2`).
- Boot disk: Choose an appropriate boot disk (e.g., Debian, Ubuntu, Rocky Linux, etc.).
- Firewall:
  - Allow HTTP traffic
  - Allow HTTPS traffic (if needed)
- Select **Advanced options** to configure additional settings.
- Under the **Management** section, add your startup script in the **Startup script** field.
- Add the following network tag:
  - `http-server`

Click **Create**.

#### 2. Create a Health Check

- Go to **Compute Engine → Health checks**.
- Click **Create health check**.

Configure the health check parameters:

- Name: `my-health-check`
- Protocol: Choose the appropriate protocol (e.g., HTTP).
- Port: Specify the port to check (e.g., `80`).
- Check interval: Set the interval for health checks (e.g., `30` seconds).
- Timeout: Set the timeout for health checks (e.g., `10` seconds).
- Healthy threshold: Set the number of consecutive successful health checks before an instance is considered healthy (e.g., `2`).
- Unhealthy threshold: Set the number of consecutive failed health checks before an instance is considered unhealthy (e.g., `3`).

Click **Create**.

#### 3. Create a Managed Instance Group

- Go to **Compute Engine → Instance groups**.
- Click **Create instance group**.

Fill in the required fields:

- Name: `my-managed-instance-group`
- Instance Template: Select the instance template created in Step 1.
- Input the desired number of instances (e.g., `3`).
- Location: Select Single zone or Multi-zone.  
  Enabling multi-zone will allow the MIG to distribute instances across multiple zones for high availability.
- Region: Select the region where you want to deploy your MIG.
- Zones: Select the desired zones if using a regional MIG.
- Autoscaling: Enable autoscaling and configure the parameters.
- Minimum number of instances: Set the minimum number of instances (e.g., `1`).
- Maximum number of instances: Set the maximum number of instances (e.g., `5`).
- Target CPU utilization: Set a target CPU utilization (e.g., 60%).
- Initialization Period: Set an initial delay (e.g., `120–300` seconds) to allow for OS boot, package installation, web server startup, and startup script execution before health evaluation begins.
- Autohealing: Enable autohealing and specify the health check created in Step 2.

Click **Create**.

The MIG will be created and instances will start to be provisioned based on the instance template and the specified configuration.

---

## Validation

### Verify VM Instances

- Go to **Compute Engine → VM instances**.
- Confirm all instances are running.

### Verify MIG Health

- Go to **Compute Engine → Instance groups**.

Verify:

- Instances are healthy
- No continuous recreation is occurring
- Autoscaling is enabled

### Verify Web Service

- Open the external IP address of an instance in a browser.

Confirm:

- nginx is running
- The startup-script-generated webpage loads successfully

### Verify Health Checks

Confirm:

- The health check reports instances as healthy
- Autohealing status is healthy
- No failed probes are occurring

---

### Cleanup

- Go to **Compute Engine → Instance groups**.
- Select the MIG and click **Delete** to tear down the MIG and all associated resources.  
  Wait for the deletion process to complete before proceeding with the next steps.
- Go to **Compute Engine → Health checks** and delete the health check created in Step 2.
- Go to **Compute Engine → Instance templates** and delete the instance template created in Step 1.  
  Select the three dots and click **Delete**, then enter the word `delete` in the dialog box to remove the instance template from your project.

---

## Terraform

**Explain the mandatory (required) arguments for a VM in terraform**

Mandatory arguments:  
Reference: <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance>

- `name`: The name of the instance.
- `machine_type`: The machine type to use for the instance (e.g., `n1-standard-1`).
- `boot_disk`: The configuration for the boot disk, including the image to use (e.g., `debian-cloud/debian-10`).
- `network_interface`: The configuration for the network interface, including the network and subnetwork to use (e.g., `default`).

**Choose 2 non-required arguments and give an explanation for both (do
not copy and paste the reference material)**

Optional arguments:

- `description`: A description of the instance which can be helpful for documenting the prupose of the VM.
- `tags`: A list of tags to apply to the instance (e.g., `["web", "production"]`).

**Explain how to output the internal and external IP addresses of the
provisioned VM and how you figured this out.**

To provide an output for the internal and external IP address of a VM, you add the output block in a terraform configuration file (e.g., `outputs.tf`) with the following parameters:

```
output "internal_ip" {
  value = google_compute_instance.example.network_interface[0].network_ip
}

output "external_ip" {
  value = google_compute_instance.example.network_interface[0].access_config[0].nat_ip
}
```
[NOTE] access_config is required to have an external IP address, so if you do not have an access_config block in your network_interface configuration, the external_ip output will not work.

Reference: https://developer.hashicorp.com/terraform/language/block/output
Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#nested_network_interface


**Explain how you would figure out the correct format for creating a VM with
the “centOS stream 10” image (the specific image is up to you).**

- Access the GCP console and go to the *Compute Engine → Storage → Images* section. 
- Use the filter bar to find the specific image (e.g., `centos-stream-10-v20260505`). 
- Click on the image to view its details, including architecture, family, and project information.
- Use the image details to construct the correct format for the `boot_disk` argument in Terraform, which typically follows the format: `project/image-family/image-name` (e.g., `centos-cloud/centos-stream-10-v20260505`).

So in terraform, the `boot_disk` argument would be configured as follows:

```
boot_disk {
  initialize_params {
    image = "centos-cloud/centos-stream-10-v20260505"
  }
}
```

**Explain the difference between the “name” argument and the computed
“id” and “self_link” attributes**

The name argument is a User-defined VM name that you provide when creating a resource. It must be unique with the project and region/zone.

The ID field is internal to Terraform and is used as an identifier for the resource.

The self_link is a Full REST API URL of the resource. The identifier is used for API calls and is globally unique across all projects and regions.