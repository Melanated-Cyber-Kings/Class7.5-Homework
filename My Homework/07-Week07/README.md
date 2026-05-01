# **SEIR_Foundations – Lab 4 GCP Branch: Multi-Cloud Connectivity Foundation**

## **Project Overview**
This Terraform project deploys the **Google Cloud (GCP)** side of the multi-cloud connectivity lab (**Lab 4: The “New York Branch”**). It establishes core networking, compute, and identity primitives in `us-central1`.

The environment is a building block of the **Signature Convergence Project “Elastic AI Gateway”**, providing the GCP landing zone that will eventually host containerised data services and AI/LLM components.

**Standard:** All resources must be **Secure, Compliant, Auditable, and Evidence-Based**. Every deployment step must be validated with logs, metrics, and gate checks.

---

## **Architecture**
![Diagram](https://via.placeholder.com/400?text=GCP+Lab+4+Topology)  
*(Placeholder – generate from `terraform graph` or Cloud Architecture Diagram tool)*

**Key Components:**
- **VPC:** Custom VPC `food` with regional routing, no default subnets.
- **Subnet:** `private-subnet` (10.0.0.0/18) in `us-central1`, with secondary IP ranges for Kubernetes Pods & Services (planned future use).
- **Hybrid Connectivity Primitives:**
  - Cloud Router (`router`, ASN 64514) – ready for BGP peering with AWS Transit Gateway.
  - Cloud NAT with a manually reserved external IP – allows private VMs to reach internet for updates and API access.
- **Compute:** A single Debian 11 VM (`lab-vm`) provisioned with a startup script that clones the SEIR-1 curriculum repository and runs validation scripts. Nginx is installed for basic HTTP testing.
- **Firewall:** Lab-scoped rules for SSH (22), HTTP (80), HTTPS (443), ESP (UDP/500 for IPsec), and RDP (3389) – all open to `0.0.0.0/0` for learning, but will be hardened later.
- **State Management:** Terraform state stored remotely in a GCS bucket (`bucket-class75-van`).

---

## **Prerequisites**

1.  **GCP Project** with billing enabled.  
    *Project ID:* `class75-van`
2.  **Permissions:**  
    - `roles/compute.admin`  
    - `roles/iam.serviceAccountUser` (to attach service accounts)  
    - `roles/storage.admin` (for the backend bucket)
3.  **Terraform** `>= 1.5` installed locally.
4.  **gcloud CLI** authenticated via `gcloud auth application-default login` or a service account key.  
    *The provider block uses default credentials* – ensure environment variable `GOOGLE_APPLICATION_CREDENTIALS` is set if not using User ADC.
5.  **Backend Bucket:** The GCS bucket `bucket-class75-van` **must already exist** before running `terraform init`. Create it manually:  
    ```bash
    gsutil mb -l us-central1 gs://bucket-class75-van
    ```

---

## **File Structure**

| File | Purpose |
| :--- | :--- |
| `0-authentication.tf` | Provider and project configuration. |
| `1-backend.tf` | Remote state backend and a persistent disk (`grafana_disk`) for future observability. |
| `2-vpc.tf` | Enables APIs and defines the custom VPC `food`. |
| `3-subnets.tf` | Private subnet with alias IP ranges for Kubernetes. |
| `4-router.tf` | Cloud Router for BGP (ASN 64514). |
| `5-nat.tf` | Cloud NAT with static external IP. |
| `6-firewall.tf` | Firewall rules for lab connectivity. |
| `7-compute.tf` | VM instance with startup script (clones SEIR-1, runs `supera.sh`). |
| `8-outputs.tf` | Outputs for VM IPs and connection commands. |
| `19-food.tf` | Local file resource for variable demo (favorite food). |
| `98-variables.tf` | Input variable `favorite_food`. |

---

## **Deployment Instructions**

### **Step 1: Authenticate**
```bash
gcloud auth application-default login
```
Or set `GOOGLE_APPLICATION_CREDENTIALS` if using a service account.

### **Step 2: Initialize Terraform**
```bash
terraform init
```
The backend bucket must pre-exist; Terraform will configure the GCS remote state.

### **Step 3: Review Plan**
```bash
terraform plan -out=tfplan
```
Verify the creation of 13 resources. Pay special attention to:
- The VPC name `food`.
- The subnet CIDR ranges for overlap.
- The NAT IP allocation.

### **Step 4: Apply**
```bash
terraform apply tfplan
```
Confirm by typing `yes`. Record the outputs for SSH access.

---

## **Validation & Evidence (Gate Checks)**

After deployment, gather the following evidence to prove the environment meets requirements:

1.  **VPC Existence**
    ```bash
    gcloud compute networks list --filter="name=food"
    ```
    *Evidence:* Output shows VPC `food` with `SUBNET_MODE=CUSTOM`.

2.  **Subnet & Secondary Ranges**
    ```bash
    gcloud compute networks subnets list --network=food
    ```
    *Evidence:* Subnet `private-subnet` in `us-central1` with ranges `k8s-pod-range` and `k8s-service-range`.

3.  **Cloud NAT**
    ```bash
    gcloud compute routers nats list --router=router --region=us-central1
    ```
    *Evidence:* NAT gateway named `nat` with manual IP allocation. Confirm external IP address.

4.  **Compute Instance & Startup Script**
    ```bash
    gcloud compute instances describe lab-vm --zone=us-central1-a \
      --format="value(metadata.items.startup-script)"
    ```
    *Evidence:* Instance running; check that Nginx is active:  
    `curl http://<EXTERNAL_IP>` → should return Nginx default page.

5.  **Firewall Rules**
    ```bash
    gcloud compute firewall-rules list --filter="network=food"
    ```
    *Evidence:* Six rules present (`allow-ssh`, `allow-http`, …).

6.  **Favorite Food Output**
    ```bash
    terraform output favorite_food
    ```
    *Evidence:* Output contains “My favorite food is fried ripe plantain”.

> **Evidence-Based Reporting Protocol:** For any claim (e.g., “The VM is reachable”), attach the exact command output and timestamp. Do not rely on assumptions.

---

## **Security & Compliance Notes**

- **Firewall rules are intentionally permissive** (`0.0.0.0/0`) for initial lab learning. As per the **SEIR_Foundations Lab 4**, these will be restricted to specific source IPs or Cloud VPN peer ranges once hybrid connectivity is established.
- **IAM:** Currently relying on default service account for the VM. In production, a dedicated, least-privilege service account should be attached.

---

## **Next Steps (Roadmap Alignment)**

1.  **Complete Lab 4 VPN + BGP:** Deploy the AWS side (Transit Gateway, VPN) and establish BGP peering using the Cloud Router’s ASN 64514.  
    *Gate Check:* `show ip bgp summary` on Cloud Router shows state = `Established`.
2.  **Proceed to Certification Phases:** With GCP networking stable, the environment can host the **Elastic Cloud on Kubernetes (ECK)** deployment (Phase 2). The secondary IP ranges already anticipate private GKE clusters.
3.  **Infrastructure as Code Hygiene:** Extract this project into reusable Terraform modules (Phase 3) and implement a CI/CD pipeline for drift detection.

---

## **Contributing & Evidence Repository**

All changes must be documented in version control (Git).  
Every pull request must include:
- `terraform plan` output before apply.
- Post-apply gate check results (screenshots or text logs).
- Updated `README.md` if architecture changes.

**Progress is measured in commits, not hours studied.**

---

*Vany FERRAND Senior Principal Multi-Cloud Architect