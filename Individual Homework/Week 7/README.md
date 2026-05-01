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
![GitHub repo1](./01)

1.2 - Give your repository a name. Click 'On' for the [Add RREADME] section. Choose "Terraform" on the [Add .gitignore] section. (A **.gitignore** file tells Git which files or directories to ignore so they aren't tracked or uploaded to your repository.)
![GitHub repo2](./02)

1.3 - Create a file in the "Homework File". Open Visual Studio Code from that folder. Open a new Terminal and make sure we are using Git Bash.
![New file](./03)
![Open VSCode](./04)
![VSCode terminal](./05)
![VSCode Git Bash](.06)

1.4 - Go back to your new repository on GitHub. Press the green "Code" button. Then copy the **HTTPS** link.
![Copy GitHub link](.07)

1.5 - Go back to Visual Studio Code. Use the command [git clone https://github.com/YOURNAME/YOURFILE.git]. This will clone the repository to your local machine.
![Git clone](./08)

1.6 - Create an 'Infra' folder. In the command line, move into the clone file with command [cd FILENAME]. Then make a new Infra folder with command [mkdir Infra]. This can also be done by clicking but I want more practice using command lines.
![Create Infra File](./08a)

### 2. Provider file
2.1 - Create an 'Provider' file. In the command line, move into the Infra file with command [cd FILENAME]. Then make a new Provider file with command [touch 0-provider.tf].
![Create Provider File](./09)

2.2 - We are now going to look at documentation at www.registry.terraform.io. Then search for "Google Provider Configuration Reference"
![Registry TF](./10)

2.3 - Press the purple "USE PROVIDER" button. Then copy the code.
![Use Provider](./11)

2.4 - Go back to Visual Studio Code and paste the code into the 0-provider.tf file.
![Code in Provider file](./12)

2.5 - **Always make sure to save files as you go along or Terraform commands will not work!**
![Save file](./13)

2.6 - Go back to the registry website. On the same page, copy the 'Basic provider blocks'. Use this to replace the 'provider' section in the code.
![Basic provider block](./14)

2.7 - Go to your Google Cloud console and copy your 'Project ID'. Use this to replace the 'Project' section in the code.
![ProjectID](./15)
![ID_Into_Code](./16)

### 3. Authenticate into your GCP account
3.1 - Use command [gcloud auth application-default login]. This will direct you to a Google login page on a web browser. After you login, you will see a page confirming your authentication.
![Auth login](./17)
![Auth confirm](./18)

### 4. Initialise and Validate Provider File
4.1 - Use command [terraform init]. This will confirm Terraform has been initialised, and show the version of Terraform being used. It will also produce a .terraform.lock.hcl file and .terraform folder (don't touch these).
![tf init provider](./19)

4.2 - Use command [terraform validate]. This checks if your config is written correctly and makes sense internally.
![tf validate provider](./20)

### 5. VPC file
5.1 - In the command line, make a new VPC file with command [touch 0-vpc.tf].
![Create VPC File](./21)

5.2 - Go back to the Terraform Registry webpage. In the 'Google Documentation' section on the left, enter "google_compute_network". This is what is used for VPCs. Press the link with the matching name. Copy the 'Network Basic' code. Then paste it into the '1-vpc.tf' file.
![tf registry vpc](./22)

5.3 - We will repete the commands [terraform init] and [terraform validate], as we will with every file we create.
![tf init val vpc](./23)

5.4 - Enter the command [terraform plan]. This previews the changes.
![tf plan vpc](./24)

5.5 - Enter the command [terraform apply]. It will ask 'Do you want to perform these actions' to confirm changes again. Enter 'yes'. This also created a 'terraform.tfstate' file. This is Terraform's record of what real resources it's currently tracking, don't toch this either.
![tf apply](./25)

5.6 - Go to your GCP console. Search 'VPC networks'. You should see the network 'vpc-network' has been created.
[vpc in gcp](./26)

### 6. Text file
6.1 - In command line enter [touch FILENAME.tf]. I went with '2-favoritefood.tf'
![create food file](./27)

6.2 - Go back to Terraform registry. Search "local_file". Copy the example used, then 
![tf reg localfile](./28a)

6.3 - Paste the code into the 2-fovoritefood.tf file. Edit the content of the file with relevant information. ${path.module} is the folder path where your curent Terraform module lives.
![edit food file](./28)

6.4 - We will repete the commands [terraform init] and [terraform validate], as we will with every file we create.
![tf init val food](./29)

6.5 - Enter the command [terraform plan] to preview the changes.
![tf food vpc](./30)

5.5 - Enter the command [terraform apply]. It will ask 'Do you want to perform these actions' to confirm changes again. Enter 'yes'. This has now created a 'Favorite Food' text file.
![tf apply](./31)
![tf txt file](./31a)

### 7. Outputs
7.1 - Go back to google and search 'Terraform Output block'. Go to the Terraform link 'Output block reference - Terraform'. Scroll down until you find [value] and copy that code.
![tf reg output](./32a)

7.2 - Paste the code into the "1-vpc.tf" file. We are adding it to this file as we want the output of the contents of this file. We could also start an output file of its own. Then edit the relevant details of the code.
![tf output code](./32)

7.3 - Run [terraform plan]. It shows it plans to add changes to the outputs. Then run [terraform apply]. After confirming with 'yes', it displays the name of the VPC. Now we can confirm what VPC is present without having to go back into GCP console.
![tf plan apply output](./33)

 

---

## Post Deployment
Now we have successfully completed our desired tasks, we will destroy the infrastructure we have built. As long as we have the file, we can always get them back. 
In the command line, enter [terraform destroy]. It will show you what it plans to destroy. Confirm your decision with a 'yes' and it will complete the task.
![tf destoy](./34)

You can confirm the VPC that was create is not still up by looking at the GCP console.
![tf destroy gcp](./35)


---

## Issues & Troubleshooting

### 1. Authentication
I attempted [terraform init] after 2.7. It didn't provide the usual outcome. Then I realised, I was not yet authenticated in my GCP account. Ideally, even though things still worked, I should have done [Procedure 3] before [Procedure 2].
### 2. Error with terraform init on 2-favoritefood.tf
When I entered [terraform init] at 6.4, I recieved the error below. I left a gap inbetween 'favorite food' next to the local file. I learned that there must be no space, so I renamed it 'favoritefood', 'favorite_food' could have also worked.
![tf init food error](./29e) error](./)

---

## Documentation Used
Provider configuration [[https://registry.terraform.io/providers/hashicorp/google/latest/docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#example-usage---basic-provider-blocks)

Google VPC 
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network#example-usage---network-basic

Terraform local_file [https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file)
Terraform outputs [https://developer.hashicorp.com/terraform/language/values/outputs](https://developer.hashicorp.com/terraform/language/values/outputs)
