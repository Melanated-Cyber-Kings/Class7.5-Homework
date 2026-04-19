

## Purpose Statement: Terraform Basics Lab

The purpose of this exercise is to build a foundational understanding of Terraform by applying its core workflow to real cloud resources. Through the creation of a Google Cloud Storage (GCS) bucket, backend configuration, and Virtual Private Cloud (VPC) setup, this lab demonstrates how infrastructure can be provisioned, validated, and managed using Infrastructure as Code (IaC).

Learners will execute and capture key Terraform commands—including `terraform init`, `terraform validate`, `terraform plan`, `terraform apply`, and `terraform destroy`—to understand the lifecycle of infrastructure deployment. Additionally, system verification using `date && hostname && whoami` reinforces environment awareness and execution context.

By progressing through authentication, backend configuration, and VPC deployment steps, this lab reinforces best practices in modular Terraform usage, state management, and repeatable infrastructure provisioning.


## Terraform Basics Lab Steps

### Step 1: Create a GCS Bucket
- Create a Google Cloud Storage (GCS) bucket to be used for Terraform state management.
<img width="1028" height="255" alt="image" src="https://github.com/user-attachments/assets/7393cb2c-1c12-429e-9eec-f4411c10121b" />
<img width="710" height="535" alt="image" src="https://github.com/user-attachments/assets/f5824b27-3ba2-48e0-a8f3-140a7c9df013" />
<img width="380" height="81" alt="image" src="https://github.com/user-attachments/assets/5f653f9e-ecd0-47b6-85d2-8ac774ba5e91" />







---

### Step 2: Run Authentication Configuration (`0-authentication.tf`)
Execute the following Terraform commands:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

### Step 3: Configure Backend (0-authentication.tf + 1-backend.tf)
Run the backend configuration with updated initialization:

```bash
terraform init -upgrade
terraform validate
terraform plan
terraform apply
```



### Step 4: Deploy VPC (0-authentication.tf + 1-backend.tf + 2-vpc.tf)
Execute Terraform with VPC configuration included:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

### Step 5: Destroy Infrastructure

Clean up all resources created during the lab using Terraform destroy:

```bash
terraform destroy
```

### Step 6: Verify System Information (Git Bash)

Run the following command in your Git Bash terminal to confirm system context:

```bash
date && hostname && whoami
```

date: Displays the current system date and time
hostname: Shows the name of the machine
whoami: Identifies the current logged-in user
