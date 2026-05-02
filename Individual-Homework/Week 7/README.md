## Purpose Statement: Terraform VPC and Local File Lab

The purpose of this lesson is to strengthen foundational Terraform and Infrastructure as Code (IaC) skills by deploying and managing cloud resources within Google Cloud Platform (GCP). Students will learn how to configure the Google Terraform provider, create a Virtual Private Cloud (VPC) named `week7hw-food`, and generate local resources using Terraform.

This exercise also introduces students to Terraform outputs, local file resources, and repository organization best practices through the creation of a dedicated GitHub repository and supporting README documentation. As part of the deployment, Terraform will create a text file containing the favorite food value `"Ice Cream"` using the `local_file` resource.

By completing this lab, students will gain practical experience with:
- Terraform provider configuration
- GCP VPC deployment
- Terraform resource outputs
- Local file creation with Terraform
- GitHub repository structure and documentation practices
- Infrastructure validation through successful Terraform deployment screenshots

The overall goal is to build confidence in writing, organizing, and deploying Terraform configurations while understanding how Infrastructure as Code can automate both cloud and local resource management.



# Terraform VPC and Favorite Food Lab Steps

## Step 1: Initialize Terraform

Run the Terraform initialization command to download the required providers and prepare the working directory.

```bash
terraform init
```

Expected result:
- Terraform initializes the backend
- Google and Local providers are installed
- Terraform is ready for use

Example output:

```bash
Terraform has been successfully initialized!
```

---

## Step 2: Validate Terraform Configuration

Run the validation command to check the syntax and configuration files.

```bash
terraform validate
```

### Common Error Example

An incorrect command spelling may produce an error:

```bash
terraform vaidate
```

Output:

```bash
Terraform has no command named "vaidate". Did you mean "validate"?
```

### File Reference Error Example

Before the `food.txt` file exists, Terraform may return this error:

```bash
Error: Invalid function argument

Invalid value for "path" parameter: no file exists at "./food.txt"
```

This happened because the configuration attempted to read a file before Terraform created it with the `local_file` resource.

### Correct Validation Result

After correcting the configuration:

```bash
terraform validate
```

Successful output:

```bash
Success! The configuration is valid.
```

---

## Step 3: Run Terraform Plan

Run the Terraform plan command to preview the infrastructure changes before deployment.

```bash
terraform plan
```

Terraform displays the resources that will be created:

- Google Cloud VPC named `week7hw-food`
- Local text file named `food.txt`
- Output values for:
  - `favorite_food`
  - `vpc_name`

Example planned resources:

```bash
Plan: 2 to add, 0 to change, 0 to destroy.
```

### Common Typo Example

Incorrect command:

```bash
terrafrom plan
```

Output:

```bash
bash: terrafrom: command not found
```

Correct command:

```bash
terraform plan
```

---

## Step 4: Apply Terraform Configuration

Deploy the infrastructure resources using:

```bash
terraform apply
```

Terraform will ask for confirmation:

```bash
Enter a value:
```

Type:

```bash
yes
```

Terraform creates:
- GCP VPC Network
- Local favorite food file (`food.txt`)

Example successful output:

```bash
Creation complete after 53s
```

---

## Step 5: Verify Terraform Outputs

After deployment, Terraform displays output values.

Example outputs:

```bash
favorite_food = "Ice-Cream"
vpc_name = "week7hw-food"
```

These outputs confirm:
- The local file resource was successfully created
- The VPC network was successfully deployed in GCP

---

## Step 6: Destroy Terraform Resources

Clean up all created infrastructure resources.

```bash
terraform destroy
```

Terraform will request confirmation:

```bash
Enter a value:
```

Type:

```bash
yes
```

Terraform removes:
- GCP VPC
- Local file resource
- Associated Terraform-managed resources

---

## Step 7: Verify System Information

Run the following command in Git Bash to verify the execution environment:

```bash
date && hostname && whoami
```

This command displays:
- Current system date and time
- Host machine name
- Logged-in user

Example:

```bash
Thu May 1 00:30:00 UTC 2026
LAPTOP-75CEFP9U
cyber
```

---

# Deliverables Checklist

- [x] Terraform provider configuration
- [x] GCP VPC creation
- [x] Local file creation (`food.txt`)
- [x] Terraform outputs
- [x] GitHub repository
- [x] README documentation
- [x] Successful deployment screenshots
- [x] Terraform validation and plan screenshots
- [x] Terraform apply output screenshot
- [x] Terraform destroy execution
```