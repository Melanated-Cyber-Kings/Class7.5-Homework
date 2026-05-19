# Week 7 Terraform Homework – GCP Infrastructure as Code

## Objective
This project shows how to deploy Infrastructure as Code (IaC) on Google Cloud Platform (GCP). It uses Terraform to automate the setup of a Virtual Private Cloud (VPC), along with generating a text file and outputs.

We are going to create a new repository on GitHub for this project. Then are going to use documentation to find code from Terraform Registry to create a basic VPC, a local file and outputs. 

The local file will be a text file with my favourite food as content. The output will be of the name of the VPC.

---

## Prerequisites
Before starting, ensure you have:
+ An active Google Cloud Platform (GCP) account
- Visual Studio Code / Bash
- Terraform installed and working
- GitHub account

---

## Procedure

### 1. Create and Clone new GitHub repository. 
1.1 - Go to github.com. Press the green button that says "New repository"
![GitHub repo1](./Screenshoots/01_Create_New_Repo1.png)

1.2 - Give your repository a name. 
Click 'On' for the [Add RREADME] section. 
Choose "Terraform" on the [Add .gitignore] section. (A **.gitignore** file tells Git which files or directories to ignore so they aren't tracked or uploaded to your repository.)
![GitHub repo2](./Screenshots/02_Create_New_Repo.png)

1.3 - Create a file in the "Homework File". 
Open Visual Studio Code from that folder. 
Open a new Terminal and make sure we are using Git Bash.
![New file](./Screenshots/03_Create_New_Folder.png)
![Open VSCode](./Screenshots/04_Open_VSCode.png)
![VSCode terminal](./Screenshots/05_VSCode_New_Terminal.png)
![VSCode Git Bash](./Screenshots/06_VSCode_GitBash.png)

1.4 - Go back to your new repository on GitHub. 
Press the green "Code" button. Then copy the **HTTPS** link.
![Copy GitHub link](./Screenshots/07_Copy_GitHub_Link.png)

1.5 - Go back to Visual Studio Code. 
Use the command [git clone https://github.com/YOURNAME/YOURFILE.git]. 
This will clone the repository to your local machine.
![Git clone](./Screenshots/08_gitclone.png)

1.6 - Create an 'Infra' folder. 
In the command line, move into the clone file with command [cd FILENAME]. 
Then make a new Infra folder with command [mkdir Infra]. 
This can also be done by clicking but I want more practice using command lines.
![Create Infra File](./Screenshots/08a_Create_Infra_File.png)

### 2. Provider file
2.1 - Create an 'Provider' file. 
In the command line, move into the Infra file with command [cd FILENAME]. 
Then make a new Provider file with command [touch 0-provider.tf].
![Create Provider File](./Screenshots/09_Create_Provider_File.png)

2.2 - We are now going to look at documentation at www.registry.terraform.io. 
Then search for "Google Provider Configuration Reference"
![Registry TF](./Screenshots/10_Registary_ProviderConfigRef.png)

2.3 - Press the purple "USE PROVIDER" button. 
Then copy the code.
![Use Provider](./Screenshots/11_UseProvider.png)

2.4 - Go back to Visual Studio Code and paste the code into the 0-provider.tf file.
![Code in Provider file](./Screenshots/12_Code_To_Provider_File.png)

2.5 - **Always make sure to save files as you go along or Terraform commands will not work!**
![Save file](./Screenshots/13_Save_Files.png)

2.6 - Go back to the registry website. 
On the same page, copy the 'Basic provider blocks'. 
Use this to replace the 'provider' section in the code.
![Basic provider block](./Screenshots/14_Basic_Provider_Blocks.png)

2.7 - Go to your Google Cloud console and copy your 'Project ID'. 
Use this to replace the 'Project' section in the code.
![ProjectID](./Screenshots/15_ProjectID.png)
![ID_Into_Code](./Screenshots/16_ID_Into_Code.png)

### 3. Authenticate into your GCP account
3.1 - Use command [gcloud auth application-default login]. 
This will direct you to a Google login page on a web browser. 
After you login, you will see a page confirming your authentication.
![Auth login](./Screenshots/17_Auth_Login.png)
![Auth confirm](./Screenshots/18_authenticated.png)

### 4. Initialise and Validate Provider File
4.1 - Use command [terraform init]. 
This will confirm Terraform has been initialised, and show the version of Terraform being used. 
It will also produce a .terraform.lock.hcl file and .terraform folder (don't touch these).
![tf init provider](./Screenshots/19_provider_tfinit.png)

4.2 - Use command [terraform validate]. 
This checks if your config is written correctly and makes sense internally.
![tf validate provider](./Screenshots/20_provider_tfval.png)

### 5. VPC file
5.1 - In the command line, make a new VPC file with command [touch 0-vpc.tf].
![Create VPC File](./Screenshots/21_Create_VPC_File.png)

5.2 - Go back to the Terraform Registry webpage. 
In the 'Google Documentation' section on the left, enter "google_compute_network". 
This is what is used for VPCs. 
Press the link with the matching name. 
Copy the 'Network Basic' code. 
Then paste it into the '1-vpc.tf' file.
![tf registry vpc](./Screenshots/22_tfregistry_vpc.png)

5.3 - We will repete the commands [terraform init] and [terraform validate], as we will with every file we create.
![tf init val vpc](./Screenshots/23_VPC_tfinitval.png)

5.4 - Enter the command [terraform plan]. 
This previews the changes.
![tf plan vpc](./Screenshots/24_VPC_tfplan.png)

5.5 - Enter the command [terraform apply]. 
It will ask 'Do you want to perform these actions' to confirm changes again. Enter 'yes'. 
This also created a 'terraform.tfstate' file. 
This is Terraform's record of what real resources it's currently tracking, don't toch this either.
![tf apply](./Screenshots/25_VPC_tfapply.png)

5.6 - Go to your GCP console. 
Search 'VPC networks'. 
You should see the network 'vpc-network' has been created.
[vpc in gcp](./Screenshots/26_VPC_In_CloudConsole.png)

### 6. Text file
6.1 - In command line enter [touch FILENAME.tf]. 
I went with '2-favoritefood.tf'
![create food file](./Screenshots/27_Create_food_File.png)

6.2 - Go back to Terraform registry. 
Search "local_file". 
Copy the example used.
![tf reg localfile](./Screenshots/28a_tfregistry_localfile.png)

6.3 - Paste the code into the 2-fovoritefood.tf file.
Edit the content of the file with relevant information. 
${path.module} is the folder path where your curent Terraform module lives.
![edit food file](./Screenshots/28_Edit_Food_File.png)

6.4 - We will repete the commands [terraform init] and [terraform validate], as we will with every file we create.
![tf init val food](./Screenshots/29_Food_tfinitval.png)

6.5 - Enter the command [terraform plan] to preview the changes.
![tf food vpc](./Screenshots/30_food_tfplan.png)

5.5 - Enter the command [terraform apply]. 
It will ask 'Do you want to perform these actions' to confirm changes again. 
Enter 'yes'. 
This has now created a 'Favorite Food' text file.
![tf apply](./Screenshots/31_food_tfapply.png)
![tf txt file](./Screenshots/31a_food_txtfile.png)

### 7. Outputs
7.1 - Go back to google and search 'Terraform Output block'. 
Go to the Terraform link 'Output block reference - Terraform'. 
Scroll down until you find [value] and copy that code.
![tf reg output](./Screenshots/32a_outputblock.png)

7.2 - Paste the code into the "1-vpc.tf" file. 
We are adding it to this file as we want the output of the contents of this file. 
We could also start an output file of its own. 
Then edit the relevant details of the code.
![tf output code](./Screenshots/32_output_code.png)

7.3 - Run [terraform plan]. 
It shows it plans to add changes to the outputs. 
Then run [terraform apply]. 
After confirming with 'yes', it displays the name of the VPC. 
Now we can confirm what VPC is present without having to go back into GCP console.
![tf plan apply output](./Screenshots/33_output_tfplanapply.png)

 

---

## Post Deployment
Now we have successfully completed our desired tasks, we will destroy the infrastructure we have built. 
As long as we have the file, we can always get them back. 
In the command line, enter [terraform destroy]. 
It will show you what it plans to destroy. 
Confirm your decision with a 'yes' and it will complete the task.
![tf destoy](./Screenshots/34_tfdestroy.png)

You can confirm the VPC that was create is not still up by looking at the GCP console.
![tf destroy gcp](./Screenshots/35_tfdestroy_vpc.png)


---

## Issues & Troubleshooting

### Issue 1. Authentication
I attempted [terraform init] after 2.7. It didn't provide the usual outcome. Then I realised, I was not yet authenticated in my GCP account. Ideally, even though things still worked, I should have done [Procedure 3] before [Procedure 2].

### Issue 2. Error with terraform init on 2-favoritefood.tf
When I entered [terraform init] at 6.4, I recieved the error below. I left a gap inbetween 'favorite food' next to the local file. I learned that there must be no space, so I renamed it 'favoritefood', 'favorite_food' could have also worked.
![tf init food error](./Screenshots/29e_Food_tfinit_error.png)

---

## Documentation Used
Provider configuration [[https://registry.terraform.io/providers/hashicorp/google/latest/docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#example-usage---basic-provider-blocks)

Google VPC 
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network#example-usage---network-basic

Terraform local_file [https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file)

Terraform outputs [https://developer.hashicorp.com/terraform/language/values/outputs](https://developer.hashicorp.com/terraform/language/values/outputs)
