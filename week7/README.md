# Week 7 Homework

## Provider.tf

**References used:**
- [Terraform Registry Google Provider Page](https://registry.terraform.io/providers/hashicorp/google/latest)
- [Terraform Registry Local Provider Page](https://registry.terraform.io/providers/hashicorp/local/latest)

For this part of the code, I went to the Terraform Registry website and used the GCP provider page to find this code. I also added a local provider for my food.tf file because it would be run on my local machine instead of in the cloud. Then for my google provider I added the project and region so that GCP will know what project it is working in. When running a `terraform init`, Terraform will know that we are working in th GCP cloud and that is what resources we will be creating.

## vpc.tf

**References used:**
- [Terraform Registry Google Compute Network page](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)
- [Class 7.5 weekb Terraform code - VPC](https://github.com/BalericaAI/SEIR-1/blob/main/weekly_lessons/weekb/terraform/2-vpc.tf)

For this part of the project, I used the terraform registry but also went back to the last class to make sure that my code looked like the code from last weeks class. I know that code worked so I wanted mine to look as close to it as possible. This code will create the VPC in my project (seir-project-490500) and gave it a name of vpc-network.

## Output.tf

**References used:**
- [Class 7.5 weekb Terraform code - Outputs](https://github.com/BalericaAI/SEIR-1/blob/main/weekly_lessons/weekb/terraform/8-outputs.tf)

For output.tf I used last weeks class to see the structure of how the output file is supposed to look. For mine I added a description to remind me what this ouput is for, the value so that the computer knows what to output, and a sensitive tag so that terraform knows that it is safe to show that value. 

## Food.tf

**References used:**
- [Udemy Terraform for GCP Video](https://www.udemy.com/course/terraform-for-beginners-using-google-cloud/learn/lecture/28569409#overview) 

I learned how to do this file while watching the Udemy videos. The purpose of this file is to locally create a txt file called favorite_food.txt. This file will only be created locally and deleted as soon as the infrastructure is torn down. It will output my favorite food which is the value in the code.

