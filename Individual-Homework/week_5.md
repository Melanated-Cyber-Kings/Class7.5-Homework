

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
<img width="445" height="381" alt="image" src="https://github.com/user-attachments/assets/d3430273-1950-4ade-9cec-48120107e4bb" />


<br>
<br>
---

### Step 2: Run Authentication Configuration (`0-authentication.tf`)  
<img width="1191" height="485" alt="image" src="https://github.com/user-attachments/assets/20dd7c4f-4c9f-4b7c-86cf-23ca47378b75" />  
<br>
<br>

```bash
gcloud auth application-default login
```
<img width="1120" height="762" alt="image" src="https://github.com/user-attachments/assets/757e662e-90c7-4bed-af16-adfe863ee17f" />



Then execute the following Terraform commands:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```
<br>
<br>

<img width="1220" height="852" alt="image" src="https://github.com/user-attachments/assets/95f40f31-8316-486f-8b51-3ce7ff8f1366" />
<br>
<br>
<img width="836" height="102" alt="image" src="https://github.com/user-attachments/assets/ccf17d15-a1ab-41ab-a269-9e53ba20c0b9" />
<br>
<br>
<img width="1112" height="181" alt="image" src="https://github.com/user-attachments/assets/65793a02-9036-4c1e-80a9-842669f6817a" />
<br>
<br>
<img width="1342" height="851" alt="image" src="https://github.com/user-attachments/assets/6987c937-d59a-4c4f-818b-0e676d0905b0" />
<br>
<br>
<br>
<br>
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
