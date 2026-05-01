## Week 7 Homework Documentation

> by: Thomas Bell

### Step 1

- Go to [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest)
- Create a 0-authentication.tf file inside your "Infra" or "Terraform" folder
    > copy and paste the below code inside 0-authentication.tf

```bash
terraform {
    required_providers {
        google = {
        source = "hashicorp/google"
        version = "7.30.0"
        }
    }
}

```

### Step 2

> copy and paste the below code in your vscode command line to add a .gitignore file

```bash
    curl -O https://raw.githubusercontent.com/ThomasBell-dev/GCP-Class_Notes7.5/refs/heads/main/03_week/.gitignore
```

### Step 3

- Go to [Google Compute Network](https://registry.terraform.io/pro%C3%A5%C3%A7viders/hashicorp/google/latest/docs/resources/compute_network)
    - create a 1-vpc.tf file
    - copy and paste the provided code into 1-vpc.tf

### Step 4

- Go to [Terrraform Local Text File](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file)
    - create a local_file.txt
    - copy and paste the provided code
    - rename the content to your favorite food
    - rename the file extension

### Step 5

- Go to [Terraform Output Block](https://developer.hashicorp.com/terraform/cli/commands/output)
    - create a 3-outputs.tf file
    - copy and paste one of the example codes
    - rename the output to your correct vpc name
    - change the value so it matches your network

### Step 6

```bash
terraform init
```

```bash
terraform validate
```

```bash
terraform plan
```

```bash
terraform apply --auto-approve
```

> IF steps 1 - 5 were done correctly, you should see your vpc name output in the terminal as well as a text file created with your favorite food.

```bash
terraform destroy --auto-approve
```

> will destroy all your resources including the text file but don't worry, rebuild it and watch the magic happen again!
