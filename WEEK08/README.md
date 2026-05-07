# Week 8 Assignment
## GCP & Terraform

---

## Q&A

### 1. What is the difference between high availability and fault tolerance? Which is best to strive for?

**High Availability (HA)** refers to a system's ability to remain operational and accessible even when one or more of its components fail. HA is achieved through redundancy and failover mechanisms.

> **Analogy:** A supermarket with multiple checkout cashiers. If one cashier goes on break, there's a short wait, but the other cashiers handle the queue — shopping continues with just a small delay.

**Fault Tolerance** is the capability of a system to continue functioning correctly even in the event of a fault or failure in one or more of its components.

> **Analogy:** A co-pilot in a plane. If the pilot passes out, the co-pilot grabs the controls immediately and the passengers feel nothing.

**Which is best to strive for?** It depends on the impact or cost of downtime. Ask yourself:
> *"What happens if this goes down for 30 seconds?"*
- If the answer is **"users get an error"** → HA is fine.
- If the answer is **"someone could die or we lose millions"** → you need Fault Tolerance.

---

### 2. Explain the difference between autoscaling and elasticity. What is vertical and horizontal autoscaling? Is one better? Are they feasible on-prem?

| Concept | Definition |
|---|---|
| **Autoscaling** | The process of automatically and dynamically matching resources to meet performance requirements. (The tooling that enables elasticity to happen) |
| **Elasticity** | The ability of a system to automatically grow and shrink resources based on demand. Think of it as a balloon — it expands when you blow air in and shrinks when the air is let out. |

**Vertical Autoscaling (Scale Up/Down)**
Increase or decrease computing power on the same machine to automatically adjust to workload demands.

**Horizontal Autoscaling (Scale Out/In)**
Add or remove servers to handle the load. For example, adding more servers during peak traffic and reducing them when demand drops.

**Is one better?**
Horizontal scaling is generally better because:
- You can scale to thousands of servers
- Adding servers doesn't interrupt users
- If one server dies, the others keep serving traffic

**Are they feasible on-prem?**
Both are feasible on-prem for smaller companies, but cloud-based solutions are more cost-efficient since you only pay for what you use and allow for true elasticity, which wins in the long run.

---

### 3. Explain the difference between managed and unmanaged instance groups.

| Type | Description |
|---|---|
| **Managed Instance Groups (MIGs)** | Let you operate apps on multiple identical VMs with automated services including: autoscaling, autohealing, regional (multi-zone) deployment, and automatic updating. |
| **Unmanaged Instance Groups** | Let you load balance across a number of VMs that you manage yourself — no automation. |

---

### 4. Explain the different use cases for health checks used by instance groups vs. load balancers. Can they be the same?

A health check is a regular automated question asked to the server:
> *"Are you alive and working?"*

| Health Check Type | Purpose |
|---|---|
| **Instance Group** | *"Is the server live enough to keep running, or should it be replaced?"* |
| **Load Balancer** | Routes requests only to healthy targets. Like a restaurant host checking which tables are clean and ready before seating a customer — they don't care *why* a table isn't ready, they just need to know if it's ready *right now*. |

**Can they be the same?**
Yes — they can hit the same endpoint (e.g. `GET /health`).

**Are they different API calls?**
You can configure them to use the same URL but with different independent thresholds:

```
# Same URL
GET https://my-server/health  ← Load Balancer calls this
GET https://my-server/health  ← Instance Group calls this

# ...but configured independently with different thresholds
Load Balancer:   fail after 2 consecutive failures → stop sending traffic
Instance Group:  fail after 10 consecutive failures → kill and replace server
```

---

### 5. Explain the 3-tier architecture and how it relates to what you are learning.

Three-tier architecture organizes an application into three separate layers, each with a distinct job:

| Tier | Name | Description |
|---|---|---|
| 1 | **Presentation Tier (Front End)** | What the user sees and interacts with — a website, mobile app, or UI. |
| 2 | **Application Tier (Back End / Logic)** | The brains — processes requests, runs business logic, makes decisions. |
| 3 | **Data Tier (Database)** | Stores and retrieves data — databases, file storage, etc. |

> **Analogy:** Think of a restaurant the customer interacts with the front of house *(presentation)*, the kitchen processes the order *(application)*, and the pantry holds all the ingredients *(data)*.

---

## Runbook: Managed Instance Group (MIG) Deployment

**Goal:** Deploy self-healing, identical virtual machines that automatically scale based on user demand. By the end of this guide, you will have a resilient application layer that can survive the failure of a physical data center.

### Steps

1. Click the **Navigation Bar** (☰) → scroll down to **Compute Engine** and click it, or search `Compute Engine` in the GCP search bar.
2. Select **Create Instance Template**.
3. Name the template (e.g. `instance-template-20260507-174517`).
4. Scroll down and select **Allow HTTP traffic**.
5. Select **Advanced options** → **Management** → locate **Automation (Startup Script)** and paste your script URL:
   ```
   https://github.com/BalericaAI/SEIR-1/blob/main/weekly_lessons/weeka/userscripts/supera.sh
   ```
6. Select **Create** and wait for completion.
7. Click **VM Instances** → **Create VM Instance** → **Create from template** → select your newly created template.
8. Select **Instance Groups** → **Create Instance Group**.
9. Provide a name or use the default.
10. Select your newly created **Instance Template**.
11. Set **Number of instances** to `4`.
12. Set **Location** to **Multiple Zones** for HA and Fault Tolerance.
13. **Autoscaling:** Select **Configure Autoscaling** → set Minimum number of instances (default settings are fine for testing).
14. **Autohealing:** Select **Health Check** → **Create Health Check** → provide a name (e.g. `my-health-check1`).
15. Select **Create** to finish creating the Instance Group.

### Verification & Critical Configs

| Config | Why It Matters |
|---|---|
| **Multi-Zone Distribution** | If `us-central1-a` goes dark, your app stays alive in `us-central1-b` and `us-central1-c`. |
| **Health Checks with Logs** | Automatically replaces "zombie" instances — VMs that are powered on but whose internal application has crashed. |
| **Testing** | Manually delete one VM from the group; within minutes, the MIG detects the loss and spins up a replacement automatically. |

---

## Terraform

### How to Output VM IP Addresses

To display the IPs, use an `output` block that drills into the network interface attribute of the VM:

```hcl
output "vm_ip_address" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
```

---

## References

- [High Availability vs Fault Tolerance vs Disaster Recovery](https://www.geeksforgeeks.org/system-design/high-availability-vs-fault-tolerance-vs-disaster-recovery/) — for high availability and fault tolerance
- [Scaling Out vs Scaling Up & Autoscaling](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/scaling-out-vs-scaling-up#autoscaling) — for auto scaling and Elasticity 
- [Managed Instance Groups (MIGs)](https://docs.cloud.google.com/compute/docs/instance-groups#managed_instance_groups) — used for MIG, HA, Autoscaling, Scalability, Health Checking.
- [Health Checks for Load Balancers](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html) — for health checks