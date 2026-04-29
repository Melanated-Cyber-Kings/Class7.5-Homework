
# Week 7 Assignment: Terraform VPC and Subnetwork Creation

# Workflow: 
1. Authenticate with GCP cloud [NOTE] This workflow does not use environmental variables (e.g. .env, var), service accounts or the cloud shell for authentication.
2. Create terraform code. 
3. Deploy infrastructure.
4. Generate deliverables.
5. Perform teardown of infrastructure and verify all resources have been removed from your GCP project.

 
[NOTE] In this repository resources that are created will not be retained. However the project used  to support this assignment will be automatically removed by running terraform destroy. You should still verify that all resources that are listed in the terraform code were actually removed to keep your expenses to a minimum.


## Tree structure of the repository
```
├── graphics
│   ├── gcp-console-with-food-vpc.png
│   ├── terrafor-apply-yes.png
│   ├── terraform-destroy-complete-vpc-deleted.png
│   ├── terraform-destroy.png
│   ├── terraform-init-valdiate-screenshot.png
│   ├── terraform-output-textfile-evidence.png
│   ├── terraform-output.png
│   ├── terraform-plan-1-of-2.png
│   └── terraform-plan-2-of-2.png
├── README.md
└── terraform
    ├── main.tf
    ├── output.tf
    ├── provider.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    ├── terraform.tfvars
    ├── terraform.tfvars.example
    └── variables.tf
```

# Deliverables
1. Terraform code that creates a VPC and a subnetwork in the same region.
2. A text file that contains the output of terraform output command.
3. A screenshot of the terraform plan output.
4. A screenshot of the terraform apply output showing VPC name.
5. A screenshot of the terraform destroy output.
6. A screenshot of the GCP console showing that the VPC and subnetwork have been removed. 
7. Gitignore file that excludes terraform state files and any other files that should not be committed to the repository.  
8. File created by terraform including the content of the text file (e.g. cat favorite-food.txt) that contains the value of the local variable that is used in the terraform code.
9. A README file that includes the following sections:
   a. Explanation of how you completed the assignment, 
   b. Documentation used.
   c. Resources used.
   d. Issues encountered and how you resolved them.
   e. References.  




## References
Provider configuration https://registry.terraform.io/providers/hashicorp/google/latest/docs


Google VPC https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
https://docs.cloud.google.com/infrastructure-manager/docs/deploy-vpc-with-terraform
https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build

Google Compute Subnetwork https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork

terraform local_file https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file

Terraform outputs https://developer.hashicorp.com/terraform/language/values/outputs

Terraform gitignore https://github.com/github/gitignore/blob/main/Terraform.gitignore 
https://www.toptal.com/developers/gitignore 

Trimspace function https://developer.hashicorp.com/terraform/language/functions/trimspace
