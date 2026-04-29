# Week 7 Lab: Terraform Registry for Google Cloud Platform provider, VPC creation via Terraform, and local file createion via Terraform

## Create terraform directory

- Create parent folder 07-week-07/ via the following command in the vsCode terminal
```bash
mkdir 07-week-07
```
- Create a sub folder under 07-week-07/ named terraform/ via the following command in the vsCode terminal
```bash
mkdir terraform
```
- Change directory into terraform/
```bash
cd terraform
```

---

## Create 0-auth.tf

- Create 0-auth.tf inside of terraform/
```bash
touch 0-auth.tf
```
- Open the following webpage for the terraform registry
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs
  - Click the purple USE PROVIDER button
  - Copy and Paste the terraform block and provider block (under Terraform 0.13+) into 0-auth.tf

- Replace
```terraform
provider "google" {
  # Configuration options
}
```

with

```terraform
provider "google" {
  project = "class75-michaelanunda"
  region  = "us-central1"
}
```
⬆️ Reference - https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
- Save 0-auth.tf

---

## Execute the following terraform commands for 0-auth.tf

1. terraform init
2. terraform validate
3. terraform fmt
4. terraform plan
5. terraform apply -auto-approve

---

## Create .gitignore file

- Execute the following command in the terminal 
```bash
touch .gitignore
```
- Copy and Paste the content within the following website into .gitignore
  - https://github.com/github/gitignore/blob/main/Terraform.gitignore
- Add the following lines below .gitignore for Mac users
```gitignore
# Optional: editor/system noise
.DS_Store
Thumbs.db
```
- Save .gitignore

---

## Create 1-vpc.tf

- Create 1-vpc.tf inside of terraform/
```bash
touch 1-vpc.tf
```
- Open the following webpage for the terraform registry
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
  - Copy and Paste the terraform block under "Example Usage - Network Basic" into 1-vpc.tf
- Save 1-vpc.tf

---

## Execute the following terraform commands for 1-vpc.tf

1. terraform validate
2. terraform fmt
3. terraform plan
4. terraform apply -auto-approve

---

## Create 2-text_file.tf

- Create 2-text_file.tf inside of terraform/ 
```bash
touch 2-text_file.tf
```
- Open the following webpage for the terraform registry
  - https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
  - Copy and Paste the terraform block under "Example Usage" into 2-text_file.tf
- Save 2-text_file.tf

---

## Execute the following terraform commands for 2-text_file.tf

1. terraform init
2. terraform validate
3. terraform fmt
4. terraform plan
5. terraform apply -auto-approve

---

## Create 3-output.tf

- Create 3-output.tf inside of terraform/ 
```bash
touch 3-output.tf
```
- Add the following terraform logic to 3-output.tf
```terraform
output "vpc" {
  description = "Name of VPC in GCP"
  value = google_compute_network.vpc_network.name
}
```
⬆️ Reference - https://developer.hashicorp.com/terraform/language/block/output
- Save 3-output.tf

---

## Execute the following terraform commands for 3-output.tf

1. terraform validate
2. terraform fmt
3. terraform plan
4. terraform apply -auto-approve

---

## Gen AI Content - Repo Layout

```text
07-week-07/
├── .gitignore
├── README.md
├── step.txt
└── terraform/
    ├── 0-auth.tf
    ├── 1-vpc.tf
    ├── 2-text_file.tf
    ├── 3-output.tf
    ├── favorite_food.txt
    └── .gitignore
```
