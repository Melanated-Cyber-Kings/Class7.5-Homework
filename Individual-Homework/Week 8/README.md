# Cloud Infrastructure, Managed Instance Groups, and Terraform Guide

---

# Table of Contents

1. [High Availability vs. Fault Tolerance](#high-availability-vs-fault-tolerance)
2. [Autoscaling vs. Elasticity](#autoscaling-vs-elasticity)
3. [Managed vs. Unmanaged Instance Groups](#managed-vs-unmanaged-instance-groups)
4. [Health Checks in Cloud Infrastructure](#health-checks-in-cloud-infrastructure)
5. [Three-Tier Architecture](#three-tier-architecture)
6. [Runbook — Creating a Managed Instance Group (MIG)](#runbook--creating-a-managed-instance-group-mig)
7. [Terraform Concepts & Virtual Machine Provisioning](#terraform-concepts--virtual-machine-provisioning)
8. [Appendix - References](#appendix---references)

---

# High Availability vs. Fault Tolerance

## What is High Availability (HA)?

High Availability (HA) refers to systems designed to remain operational with minimal downtime even when failures occur. HA environments reduce service interruptions through redundancy, failover mechanisms, and distributed infrastructure.

### Characteristics
- Minimal downtime
- Redundant systems
- Multi-zone or multi-region deployments
- Automatic failover

### Example
If one server fails, traffic is redirected to another healthy server with little to no interruption.

---

## What is Fault Tolerance?

Fault Tolerance allows systems to continue operating normally even if one or more components fail.

### Characteristics
- No service interruption
- Duplicate hardware/resources
- Continuous operation
- Higher implementation cost

### Example
If a physical server component fails, another duplicate component immediately takes over.

---

## Key Differences

| Feature | High Availability | Fault Tolerance |
|---|---|---|
| Goal | Minimize downtime | Eliminate downtime |
| Cost | Moderate | High |
| Recovery | Short failover | Immediate continuation |
| Infrastructure | Redundant systems | Fully duplicated systems |

---

## Which Should Organizations Strive For?

Most organizations should strive for **High Availability** because it provides strong resiliency without the extreme costs associated with full fault tolerance.

High Availability allows:
- Multi-region deployments
- Reduced single points of failure
- Better scalability
- Lower operational costs

Fault tolerance is typically reserved for:
- Financial systems
- Healthcare systems
- Military applications
- Mission-critical environments

---

# Autoscaling vs. Elasticity

## What is Autoscaling?

Autoscaling automatically increases or decreases infrastructure resources depending on demand.

### Examples
- Adding virtual machines during traffic spikes
- Removing instances during low usage periods
- Dynamically adjusting compute resources

---

## What is Elasticity?

Elasticity refers to how quickly and automatically infrastructure can scale based on workload demand.

### Key Focus Areas
- Automation
- Speed
- Dynamic adjustments
- Cost optimization

Think of scalability as **capacity**, while elasticity focuses on **automation and responsiveness**.

---

# Vertical vs. Horizontal Scaling

## Vertical Scaling (Scaling Up/Down)

Vertical scaling increases the power of an existing machine.

### Examples
- Adding RAM
- Increasing CPU
- Expanding storage

### Advantages
- Simpler implementation
- Easier compatibility

### Disadvantages
- Hardware limitations
- Possible downtime

---

## Horizontal Scaling (Scaling Out/In)

Horizontal scaling adds or removes entire servers or instances.

### Examples
- Adding virtual machines
- Expanding application clusters
- Increasing server pools

### Advantages
- Better redundancy
- Improved availability
- Stronger fault isolation

### Disadvantages
- More architectural complexity
- Requires load balancing

---

## Which Scaling Method is Better?

In cloud environments, **horizontal scaling** is generally preferred because it:
- Supports high availability
- Improves resiliency
- Removes single points of failure
- Integrates well with distributed systems

---

# Managed vs. Unmanaged Instance Groups

## Managed Instance Groups (MIGs)

Managed Instance Groups automate deployment and lifecycle management for identical virtual machine instances.

### Features
- Autoscaling
- Autohealing
- Automated updates
- Load balancing integration
- Multi-zone deployment

### Benefits
- Reduced operational overhead
- Improved reliability
- Simplified infrastructure management

---

## Unmanaged Instance Groups

Unmanaged Instance Groups consist of manually configured VMs that may not be identical.

### Features
- Manual administration
- No autoscaling
- No autohealing
- Flexible VM configurations

### Benefits
- Supports unique instances
- Greater configuration flexibility

### Drawbacks
- Increased maintenance
- Reduced automation
- Limited resiliency

---

# Health Checks in Cloud Infrastructure

## Application Health Checks

Application health checks monitor server health and automatically replace failed instances.

### Purpose
- Detect unhealthy VMs
- Trigger autohealing
- Maintain infrastructure reliability

---

## Load Balancer Health Checks

Load balancer health checks determine which servers should receive user traffic.

### Purpose
- Prevent failed requests
- Route traffic only to healthy systems
- Improve user experience

---

## Can the Same Endpoint Be Used?

Yes. Both services can use the same endpoint such as:

```bash
/health
```

Supported platforms include:
- Google Cloud
- AWS

---

## Should They Be the Same?

Generally, no.

Best practice recommends separate configurations to avoid cascading failures.

### Example
A database outage could temporarily fail application health checks. If autoscaling and load balancing share aggressive thresholds:
- The load balancer removes healthy instances
- Autoscaling unnecessarily destroys infrastructure

---

## Deep vs. Shallow Checks

### Shallow Checks
Verify:
- Web server is running
- Port is responding

### Deep Checks
Verify:
- Database connectivity
- Cache access
- Full application functionality

---

# Three-Tier Architecture

## What is Three-Tier Architecture?

Three-tier architecture separates applications into three independent layers:

1. Presentation Tier
2. Application Tier
3. Data Tier

This design improves:
- Scalability
- Security
- Maintainability
- Resiliency

---

## 1. Presentation Tier (Frontend)

Handles:
- User interfaces
- Web pages
- Mobile applications

### Examples
- Web browsers
- Mobile apps
- Static sites

---

## 2. Application Tier (Backend)

Processes:
- Business logic
- APIs
- Authentication
- Data processing

### Examples
- Python applications
- REST APIs
- Backend services

---

## 3. Data Tier (Database)

Stores and manages persistent application data.

### Examples
- PostgreSQL
- MySQL
- Cloud SQL
- Amazon RDS

---

# Runbook — Creating a Managed Instance Group (MIG)

## Purpose of Runbook

A Managed Instance Group (MIG) in Google Cloud Platform allows engineers to automatically deploy, manage, and scale multiple identical virtual machines from a single instance template.

MIGs improve:
- High availability
- Reliability
- Scalability
- Infrastructure automation

The primary reason for using MIGs is to avoid relying on a single VM and instead deploy multiple redundant instances.

---

# Prerequisites

Before creating a MIG, ensure the following are prepared:

- VM Instance Template
- Networking configuration
- Firewall rules
- Startup scripts
- Machine type selection
- Boot disk image

---

# Step 1 — Navigate to Instance Groups

1. Open the Google Cloud Console.
2. Search for:

```bash
Instance Groups
```

3. Select **Instance Groups**.
4. Click **Create Instance Group**.

---

# Step 2 — Configure the MIG

Complete the following fields:

| Field | Recommendation |
|---|---|
| Name | Custom naming convention |
| Description | Optional |
| Number of Instances | Ideally 4 |
| Instance Template | Select existing template |

---

# Step 3 — Configure Multi-Zone Deployment

1. Under **Location**, select:

```bash
Multiple zones
```

2. Select all available zones.
3. Click **OK**.

### Benefits
- High availability
- Zone redundancy
- Disaster recovery support

---

# Step 4 — Configure Health Checks

1. Navigate to the **Health Check** section.
2. Click:

```bash
Create a Health Check
```

### Recommended Settings

| Field | Value |
|---|---|
| Scope | Regional |
| Protocol | HTTP |
| Port | 80 |
| Logs | On |
| Request Path | /health |

---

# Step 5 — Create the MIG

Click:

```bash
Create
```

Wait for deployment completion.

---

# Step 6 — Validate the Deployment

1. Open the instance group.
2. Verify healthy VM status.
3. Copy an external IP address.
4. Open the IP in a browser.

Example:

```bash
http://EXTERNAL_IP
```

Expected Result:
- Startup page loads
- Application is accessible
- Health checks pass successfully

---

# Terraform Concepts & Virtual Machine Provisioning

# Mandatory Arguments for a VM in Terraform

When using Terraform to create VMs in Google Cloud, the following arguments are required:

| Argument | Purpose |
|---|---|
| `name` | Unique VM name |
| `machine_type` | CPU and memory allocation |
| `zone` | Deployment zone |
| `boot_disk` | Operating system disk |
| `network_interface` | Network configuration |

---

## Example Terraform VM

```hcl
resource "google_compute_instance" "default" {
  name         = "terraform-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
```

---

# Outputting Internal and External IP Addresses

Terraform outputs can display VM IP addresses after deployment.

## Example

```hcl
output "external_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}

output "internal_ip" {
  value = google_compute_instance.default.network_interface[0].network_ip
}
```

---

# Non-Required Terraform Arguments

## `description`

Provides human-readable documentation for resources.

### Example

```hcl
description = "Production subnet"
```

---

## `labels`

Organizes resources using key-value metadata.

### Example

```hcl
labels = {
  environment = "production"
  team        = "devops"
}
```

---

# Using the CentOS Stream 10 Image

## Step 1 — Identify the Image

```bash
gcloud compute images list --project centos-cloud --no-standard-images | grep centos-stream-10
```

---

## Step 2 — Implement in Terraform

```hcl
data "google_compute_image" "my_image" {
  family  = "centos-stream-10"
  project = "centos-cloud"
}

resource "google_compute_instance" "default" {
  name         = "centos-10-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
```

---

# Difference Between `name`, `id`, and `self_link`

| Feature | `name` | `id` | `self_link` |
|---|---|---|---|
| Type | Input | Computed Output | Computed Output |
| Source | User-defined | Server-generated | API-generated |
| Purpose | Friendly name | Unique identifier | API resource URL |

---

# Appendix - References

## Cloud Architecture References

- Professional Cloud Architect – Google Cloud Certification Guide by Cłapa and Gerrard (2nd Edition)
- Microsoft Azure Cloud Computing Dictionary
- IBM Three-Tier Architecture Documentation

---

## Terraform References

- HashiCorp Terraform Documentation
- Fabian Lee Terraform Examples
- HashiCorp Well-Architected Framework

---

## Additional Resources

- AWS Health Check Documentation
- Stack Overflow Terraform Discussions
- Medium — Patterns for Resilient Architecture
