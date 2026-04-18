# Class7.5 Systems Engineering & Identity Responsibility (SEIR-I) Homework by Larvarious C. McDonald aka Loki Stormbringer

**Weekly Directory**

[Week 1](https://github.com/Melanated-Cyber-Kings/Class7.5-Homework/blob/Larvarious-McDonald-Homework-Branch-7.5/README.md#week-1)<br/>
[Week 2](https://github.com/Melanated-Cyber-Kings/Class7.5-Homework/blob/Larvarious-McDonald-Homework-Branch-7.5/README.md#week-2)<br/>
[Week 3](https://github.com/Melanated-Cyber-Kings/Class7.5-Homework/blob/Larvarious-McDonald-Homework-Branch-7.5/README.md#week-3)<br/>
[Week 4](https://github.com/Melanated-Cyber-Kings/Class7.5-Homework/blob/Larvarious-McDonald-Homework-Branch-7.5/README.md#week-4)<br/>
[Week 5](https://github.com/Melanated-Cyber-Kings/Class7.5-Homework/blob/Larvarious-McDonald-Homework-Branch-7.5/README.md#week-5)<br/>
[Week 5: Be A Man Extra Credit](https://github.com/Melanated-Cyber-Kings/Class7.5-Homework/blob/Larvarious-McDonald-Homework-Branch-7.5/README.md#be-a-man-extra-credit)

## Week 1 

**Installed Choco List on My PC** ✅

<img width="500" height="1000" alt="choco list" src="https://github.com/user-attachments/assets/6270e523-4767-4639-811d-98a3b923f613" />



## Week 2 

<ins>**Deploy a VM instance with supera.sh script and check the success of your deployment with the “gate” script given**</ins>

Script Result Proof<br/>

<img width="600" height="600" alt="Script Result Proof" src="https://github.com/user-attachments/assets/4076063c-9c94-45d6-8049-8ffd212efe66" />


Virtual Machine Creation Proof<br/>

<img width="600" height="600" alt="VM Proof" src="https://github.com/user-attachments/assets/8a1d68b4-0406-4f0f-83b1-6838c07197fd" />

badge.txt<br/>

<img width="500" height="500" alt="badge txt" src="https://github.com/user-attachments/assets/3d5db433-572c-4eac-b226-a64c1876df72" />

[gate_gcp_vm_http_ok.sh ](week1/gate_gcp_vm_http_ok.sh)

[gate_result.json](week1/gate_result.json)



## Week 3

### "Udemy GCP MasterClass: Section 10"

**LAB: VPC IPs Distribution**

I've created two external static IP addresses, one is regional and the other is a global static IP address.<br/>

<img width="600" height="600" alt="01-externalstaticips" src="https://github.com/user-attachments/assets/66c96162-11ce-42a5-9d72-94a0e2dc0548" />

In this diagram, I've created three VM instances. One has no external IP address, one has an external IP address, and the third one has a static IP address assigned to it.

<img width="600" height="600" alt="02-staticipsassignedtovm" src="https://github.com/user-attachments/assets/6a6aa09c-0599-443b-a539-128f2896a361" />


**LAB: Network Firewalls in GCP**

I created a VPC named "demo-vpc", with three custom subents in us-central1(Iowa).<br/>

<img width="600" height="600" alt="03-vpcnetworkwithsubnets" src="https://github.com/user-attachments/assets/57af38ae-a8c1-4280-b047-168a70a746a6" />

After creating the "demo-vpc", I tried to SSH into the myinstance-webserver and it was unsuccessful, because the firewall in my VPC is blocking SSH by default. So, I have to manually create a firewall rule that allows SSH (Port 22) into my VM instances.

<img width="600" height="600" alt="04 5 unabletosshtovminstance" src="https://github.com/user-attachments/assets/981a946a-3169-4983-a5fe-280807240447" />

In the VPC Network Tab, I created a firewall rule named "demo-vpc-ssh". I chose my VPC network "demo-vpc", and I chose the Target as "Specified Target Tags".<br/>

<img width="600" height="600" alt="05-createfirewallrule" src="https://github.com/user-attachments/assets/7d35c254-2c89-454f-85b7-b0baa6c756cc" />

Under specified ports and protocols, I chose TCP with a port of 22, and the other protocol of ICMP. 

<img width="600" height="600" alt="06 5-otherfirewallprotocols" src="https://github.com/user-attachments/assets/78f2671b-199b-4ad8-a5c0-272cf9c06c5c" />

After I created the network firewall rule, I went back to my VM Instances and edited the networking section, and added the appropriate network tags so that I could SSH into each of them.<br/>

**myinstance-db**

<img width="600" height="600" alt="07-editvminstancewithfirewalltags" src="https://github.com/user-attachments/assets/cc604582-b678-47fd-aebb-ed817968c1e4" />

**myinstance-service**

<img width="600" height="600" alt="08-editvminstancewithfirewalltags2" src="https://github.com/user-attachments/assets/f58c5060-8282-4c50-9a80-de7326cc6947" />

**myinstance-webserver**

<img width="600" height="600" alt="09-editvminstancewithfirewalltags3" src="https://github.com/user-attachments/assets/e0580571-b084-4bc5-a8b7-ebc81aab8b98" />

Once, I edited the VMs with the correct network tags, I was able to successfully SSH into my VM instances.<br/>

<img width="600" height="600" alt="10-successfulsshvminstance" src="https://github.com/user-attachments/assets/e31c8b74-7e00-451b-9e80-06521a9044d8" />


**LAB: VPC Network in GCP**

In the below diagram, I created a vpc network with automatic subnets.

<img width="600" height="600" alt="07-createautovpcnetwork" src="https://github.com/user-attachments/assets/d879d794-05b8-4fbc-84aa-081c0f5456d0" />

I also included in automatic firewall rules and attached them to this VPC network.

<img width="600" height="600" alt="08-autofirewallrules" src="https://github.com/user-attachments/assets/f98f02ca-151c-436b-9ce2-cca381f3fad4" />

Auto VPC Subnets

<img width="600" height="600" alt="09-autovpcsubnets" src="https://github.com/user-attachments/assets/09e47e01-0b0d-41af-a5e6-2e7baabb94b1" />

<img width="600" height="600" alt="10-autovpcfirewallrulescreated" src="https://github.com/user-attachments/assets/f6d415ef-937d-448d-b577-d7ba7b09dcfd" />

Here, I created another VPC network with custom subnets in different regions.

<img width="600" height="600" alt="11-customvpcsubnets" src="https://github.com/user-attachments/assets/ef56e689-574f-4edd-8b00-38ccdcad2efd" />

I created a custom firewall rule, that I will add to VM instances later on.

<img width="600" height="600" alt="12-createcustomfirewallrule" src="https://github.com/user-attachments/assets/c73eb976-22f4-48c5-ae9a-57b5948c3a0c" />

Also, with custom network tags. That's what I will add to the VM instances.

<img width="600" height="600" alt="13-createcustomfirewallrulepart2" src="https://github.com/user-attachments/assets/858f798e-b2a2-4e95-9ce2-6df0710d1ace" />

Here, I created several VM instances. Several are custom VM instances allocated to the custom VPC network, one is default and the other is connected to the auto VPC network.

<img width="600" height="600" alt="14-createdvminstances" src="https://github.com/user-attachments/assets/a6ef6316-c06f-4bca-856b-3341429a527e" />

In this below diagram, I was unable to ping to a Virtual Machine in a different VPC network.

<img width="600" height="600" alt="15-unabletopingvmindifferentvpcnetwork" src="https://github.com/user-attachments/assets/73dd5ca6-03fc-429d-ac20-4a83b978ced3" />

However, I was able to ping the external IP address from the other VPC network, but was unable to ping to the host of that same VM instance, because the external IP is open to the Internet.

<img width="600" height="600" alt="16-abletopingexternalnetworknothost" src="https://github.com/user-attachments/assets/8da93f33-64df-492a-8498-07f0418f325d" />

I tried to ping the Internal Network, but was unable as well due to Virtual Machine belonging to another VPC network.

<img width="600" height="600" alt="17-unabletopinginternalnetworkduetodifferentvpcnetwork" src="https://github.com/user-attachments/assets/6dc02df7-fb09-4231-89c7-8853e3a85f42" />

Here, I tried to ping the external IP address of a custom VM Instance I created and was unsuccessful. 

<img width="600" height="600" alt="18-unabletopingexternalipofcustomvminstance" src="https://github.com/user-attachments/assets/e5de4c06-1035-4725-bd1f-148b0867558e" />

I was unable to SSH this VM due to firewall rules on this VM instance.

<img width="600" height="600" alt="19-unabletosshduetofirewallrules" src="https://github.com/user-attachments/assets/5de9d0b3-2ee7-41b9-9ad2-69e8b7c4240c" />

To resolve the above issue, I added the network tags from the firewall rule I created earlier to this VM instance, by editing this running VM instance. 

<img width="600" height="600" alt="20-addnetworktagstocustomvms1" src="https://github.com/user-attachments/assets/a84ab4ea-aa2d-4c78-84c2-f0b61e505539" />

Adding the same network tag to this VM instance as well to fix any issues with SSH.

<img width="600" height="600" alt="21-addnetworktagstocustomvms2" src="https://github.com/user-attachments/assets/68c7db04-1024-42e1-84ac-60303b5f38af" />

Successful SSH to Custom VM 1!

<img width="600" height="600" alt="22-succesfulsshoncustomvm1" src="https://github.com/user-attachments/assets/b8067f3b-4eb8-46fb-a37b-3c334713d4bd" />

Successful Ping to Custom VM Instance1 from Auto VM Instance!

<img width="600" height="600" alt="23-successfulpingtocustomvminstance1" src="https://github.com/user-attachments/assets/525b460e-08d2-42a8-b75d-c5ff4568d2d8" />

Successful Ping To Custmo VM Instance2 from Auto VM Instance!

<img width="600" height="600" alt="24-successfulpingtocustomvminstance2" src="https://github.com/user-attachments/assets/c675e35a-4791-4068-844f-285bffd4db83" />



**LAB: Cloud VPN & VPN Tunnels**

Create Custom VPC Network

<img width="600" height="600" alt="25-createcustomvpcnetwork" src="https://github.com/user-attachments/assets/e1daf6b6-9f4b-48d8-b1df-0c1a100da8ad" />

Create Another Custom VPC Network in us-east1

<img width="600" height="600" alt="26-createanothervpcinanotherregion" src="https://github.com/user-attachments/assets/e9f01617-8c1f-49d5-95e6-77cc0aeb5f86" />

Create Firewall Rule for connectivity between machines

<img width="600" height="600" alt="27-createfirewallrule" src="https://github.com/user-attachments/assets/0623107e-f397-4054-9023-2c295c71caec" />

Firewall Ports

<img width="600" height="600" alt="28-firewallruleports" src="https://github.com/user-attachments/assets/626e6899-ac6d-46c7-b421-823c01f32c43" />

Create another Firewall Rule for VM 2

<img width="600" height="600" alt="29-createfirewallruleforvm2" src="https://github.com/user-attachments/assets/829b1add-ed80-4134-83f2-c1f62c624ccf" />

Firewall Ports for second VM

<img width="600" height="600" alt="30-vm2firewallrules" src="https://github.com/user-attachments/assets/522c0158-b552-40af-a8f6-22ae05ca3f65" />

Creating first VM Instance

<img width="600" height="600" alt="31-createvminstance1" src="https://github.com/user-attachments/assets/c97a72f6-96ab-47b3-accd-00e92ba81a5d" />

Assign first VPC to VM Instance Network

<img width="600" height="600" alt="32-assignvpc1tovminstance1" src="https://github.com/user-attachments/assets/0ba0520a-5224-476c-ad40-502b53526e7b" />

Create another VM Instance for us-east1

<img width="600" height="600" alt="33-createvminstanceforuseast1" src="https://github.com/user-attachments/assets/286da09d-61f9-4010-a7e7-6d46bc9c9e21" />

Assign second VPC to VM Instance 2 Network

<img width="600" height="600" alt="34-assignnetworktovm2" src="https://github.com/user-attachments/assets/1599cd40-0225-41fe-b145-42d3cb4201b9" />

Successful SSH on VM1

<img width="600" height="600" alt="35-successfulsshonvm1" src="https://github.com/user-attachments/assets/3707b9a4-1db8-48f0-9436-e5697731fa0e" />

Successful Ping to External IP on VM2

<img width="600" height="600" alt="36-successfulpingtoexternalipofvm2" src="https://github.com/user-attachments/assets/12839f83-b1eb-4765-aed5-3c77690e744e" />

Unable to Ping Internal IP of VM2

<img width="600" height="600" alt="37-unabletopinginternalipofvm2" src="https://github.com/user-attachments/assets/771feea8-61be-4040-a2bb-134803615dac" />

Successful Ping to Eternal IP of VM1 from VM2

<img width="600" height="600" alt="38-successfulpingtoexternipofvm1fromvm2" src="https://github.com/user-attachments/assets/8b926d54-704d-4575-a0f7-af6742b0feed" />

Unable to Ping Internal IP of VM 1

<img width="600" height="600" alt="39-unabletopinginternalipofvm1" src="https://github.com/user-attachments/assets/00429886-9259-4161-a16d-b8570cff1cf6" />

Open Cloud Shell, in order to setup VPN Network

<img width="600" height="600" alt="40-opencloudshell" src="https://github.com/user-attachments/assets/76984a35-7248-48d0-a519-a213d8351da1" />

Create VPN1 with Command in CloudShell

<img width="600" height="600" alt="41-createvpn1withcommandincloudshell" src="https://github.com/user-attachments/assets/4344e914-4e67-4393-83ea-f6c0669c8307" />

Create Static IP Address for VPN1 with this command

<img width="600" height="600" alt="42-createstaticipaddressforvpn1withthiscommand" src="https://github.com/user-attachments/assets/8df35b76-918b-46a6-8c11-96aa601e4886" />

Check for created Static IP Address

<img width="600" height="600" alt="43-checkforcreatedstaticipwiththiscommand" src="https://github.com/user-attachments/assets/dfe3c28c-b729-448a-84d1-84b7d3784bbf" />

Create Forwarding Rule for VPN1

<img width="600" height="600" alt="44-createforwardingruleforvpn1" src="https://github.com/user-attachments/assets/679863a0-f2c0-4f69-8bae-ce5e640b506b" />

Check Addresses again for Status Change

<img width="600" height="600" alt="45-checkaddressesagainforstatuschange" src="https://github.com/user-attachments/assets/5bc670c8-a03e-43fb-8bae-aa28722ae7c7" />

Create another Forwarding Rule for VM1 with UDP Port 500

<img width="600" height="600" alt="46-createanotherforwardingrulewithudp" src="https://github.com/user-attachments/assets/a973538b-31ec-491a-b032-4f5ab440f5ae" />

Create one more Forwarding Rule for VM1 with UDP Port 4500

<img width="600" height="600" alt="47-createforwardingruleforport4500udp" src="https://github.com/user-attachments/assets/eda6fe08-bf3c-4c9d-a493-dc15e52b3f9e" />

Check Forwarding Rules List

<img width="600" height="600" alt="48-checkforwardingruleslist" src="https://github.com/user-attachments/assets/fbfd8223-b046-4ebd-85e1-21d07f5f3ee5" />

Create VPN2 with Command in CloudShell

<img width="600" height="600" alt="49-createvpn2withcommandincloudshell" src="https://github.com/user-attachments/assets/4bec53c2-be7f-47fc-81b1-b9a8c77ba14a" />

List both VPN Gateways

<img width="600" height="600" alt="50-listbothvpngateways" src="https://github.com/user-attachments/assets/a5051cb9-4a62-4c3c-972d-af4d85200763" />

Create Static IP Address for VPN2

<img width="600" height="600" alt="51-createstaticipaddressforvpn2" src="https://github.com/user-attachments/assets/4624cca6-6ffd-4607-bc50-346b2ade893c" />

Confirm that both Static IP Addresses are created

<img width="600" height="600" alt="52-confirmbothstaticipaddressescreation" src="https://github.com/user-attachments/assets/0f867d6f-ed53-449c-af14-7da89b7a7ea8" />

Create another Forwarding Rule for VPN2

<img width="600" height="600" alt="53-createanotherfowardingrulevpn2" src="https://github.com/user-attachments/assets/43073a0f-416f-4fe8-a148-6b1be51b39ee" />

Create Firewall Rule UDP 4500 for VPN2

<img width="600" height="600" alt="54-createfirewallruleforudp4500" src="https://github.com/user-attachments/assets/26180290-3dc9-405d-92ef-5eb8c7f9ff3d" />

List all Forwarding Rules for both VPNs

<img width="600" height="600" alt="55-listallfowardingrules" src="https://github.com/user-attachments/assets/79e815bf-6c20-4ad9-884e-20a195e1c241" />

Create first VPN Tunnel

<img width="600" height="600" alt="56-createfirstvpntunnel" src="https://github.com/user-attachments/assets/0203bd9c-78da-43b8-8651-665fd86c97c1" />

Create Second VPN Tunnel

<img width="600" height="600" alt="57-createsecondvpntunnel" src="https://github.com/user-attachments/assets/79407617-670a-4ad8-9962-6a5dd29fbf38" />

Show both VPN Tunnels

<img width="600" height="600" alt="58-bothvpntunnels" src="https://github.com/user-attachments/assets/a744baf7-7e2c-4826-8164-d3c0bb2b8b1f" />

Create first Route for VPN Tunnel

<img width="600" height="600" alt="59-createrouteforvpntunnel" src="https://github.com/user-attachments/assets/78f7f81c-5402-4ff4-8d1a-014b64a96d05" />

Create second Route for second VPN Tunnel

<img width="600" height="600" alt="60-create2ndrouteforvpntunnel2" src="https://github.com/user-attachments/assets/aea77a5a-1b62-484e-b648-32613800f676" />

Show both Routes

<img width="600" height="600" alt="61-bothroutes" src="https://github.com/user-attachments/assets/288fb80e-e704-48e6-81ed-6c5751e0c891" />

Now, I have a successful Ping to the Internal IP Address of the VM2 from VM1

<img width="600" height="600" alt="62-successfulpingtointernalipaddressofvm2" src="https://github.com/user-attachments/assets/99a8e89f-9151-4d2b-a578-692c57969c95" />

Alas, I have a successful Ping to the Internal IP Address of VM1 from VM2

<img width="600" height="600" alt="63-sucessfulpingtointernaladdressofvm1" src="https://github.com/user-attachments/assets/8bf14632-3e1e-44e6-a32c-bd6a524f1158" />






**LAB: Cloud Routers for Routing in GCP**




### "Udemy GCP Security Engineer: Section 13"

**HANDS-ON: Explore Default VPC**

**HANDS-ON: Create Auto Mode VPC**

**HANDS-ON: Create Custom Mode VPC**

**HANDS-ON: Create Virtual Machine w/ all subnets**

**HANDS-ON: Create Firewall Rule - SSH**

**HANDS-ON: Internal vs External IP Address**

**HANDS-ON: Static vs Ephermeral IP Address**



## Week 4

N/A - Theo gave us time off (Birthday week & Illinois in NCAA Final Four) 🥳🎉

![yoda-star-wars](https://github.com/user-attachments/assets/26820918-e6b0-4927-9ec6-75cba95ed4d6)


![IlliniFan](https://github.com/user-attachments/assets/bfb9a831-9a37-4d93-b7e0-944df19448be)

<img width="225" height="225" alt="images (1)" src="https://github.com/user-attachments/assets/2fada686-e531-4450-918f-d6607e7b935e" />



## Week 5

## Reading, Videos, and Labs

**GCP**:
Professional Cloud Architect Prep Book (megafile) == Chapters 1-4 & Chapter 8
GCP Terraform Book (megafile) = Chapters 1 & 2\
GCP Masterclass (Udemy) == Videos & Labs #19 - 43 (sections 5 & 6)

### Section 5: Google Cloud Compute Engine (GCE)

**Lab : Create Google Virtual Machine**

I created a VM instance in GCP

<img width="600" height="600" alt="01-createvminstance" src="https://github.com/user-attachments/assets/ef4ccfc0-1b0a-4ed6-ba9e-8dd296fd8890" />


Then, I checked the version of Python3 on the VM Instance, and installed GIT on there as well and verified the version.

<img width="600" height="600" alt="02-installpackagesonvm" src="https://github.com/user-attachments/assets/559ba1ad-dde6-4994-8a0f-b2de1a3db975" />

**Lab : Edit Running Compute Engine**

In my current VM instance, I clicked on the edit button and add an extra 200 GB disk. <br/>

<img width="600" height="600" alt="04-adddiskonrunningvm" src="https://github.com/user-attachments/assets/743bcedb-d909-4d65-ac6a-4c657de737af" />

However, I was limited to what I could edit on a running VM instance, so I stopped the VM instance so I could change the name.<br/>

<img width="600" height="600" alt="05-editstoppedvminstance" src="https://github.com/user-attachments/assets/c110d076-afd1-413d-881b-550f423922d6" />

I also changed the machine type from E2 to N2.<br/>

<img width="600" height="600" alt="06-changedmachinetype" src="https://github.com/user-attachments/assets/73d662ce-f709-4dce-b99c-dfe822b111d9" />


**Lab : Create Custom Machine in GCP**

**Lab : Submit Startup Script | Execute Tomcat on Compute Engine**


### Section 6: Disks on Google Compute Engine

**Hands On : Disk I** 

**Hands On : Disk II**

**Hands On : Disk III**

**Hands On : Disk IV**

**Hands On : Snapshot**




**Linux**:
Linux Command Line (megafile) == chapters 1-4
Linux Fundamentals (killercoda.com) == Lessons 1-8 ✅

### Lesson 1



<img width="600" height="600" alt="01-lesson1-listfiles" src="https://github.com/user-attachments/assets/92633b6f-48d1-44f1-8a9b-83f4cc48251e" />

<img width="600" height="600" alt="01 2-lesson1-listfiles-getmoreinfo" src="https://github.com/user-attachments/assets/32cf4e7f-99ea-48b8-9e0e-d9d08443cb21" />

<img width="600" height="600" alt="02-lesson1-listallfiles" src="https://github.com/user-attachments/assets/2df55479-71e9-4458-a719-84d1c5d8d453" />

<img width="600" height="600" alt="03-lesson1-sortingfiles1" src="https://github.com/user-attachments/assets/1a70fe87-6db6-4382-a9be-e154731bcd49" />

<img width="600" height="600" alt="03-lesson1-sortingfiles2" src="https://github.com/user-attachments/assets/950ec665-0fec-43fe-8087-6d36def8d56f" />

<img width="600" height="600" alt="03-lesson1-sortingfiles3" src="https://github.com/user-attachments/assets/3eda1725-b73c-4e3e-81c1-6866fd70ac49" />

<img width="600" height="600" alt="04-lesson1-sortingfilebysize1" src="https://github.com/user-attachments/assets/c2617f17-26e3-4cc9-b518-a03625c3ba0d" />

<img width="600" height="600" alt="05-lesson1-formatting" src="https://github.com/user-attachments/assets/42e397d9-83e5-4cf2-bfc7-401f678d5928" />

<img width="600" height="600" alt="06-lesson1-otherlsoptionsandhelp" src="https://github.com/user-attachments/assets/d6f7c5a8-9b79-463e-8b69-42d113674f7a" />

<img width="600" height="600" alt="06-lesson1-otherlsoptionsandhelp2" src="https://github.com/user-attachments/assets/08c39064-c818-4875-9f2e-d74eacf3a5a2" />

<img width="600" height="600" alt="06-lesson1-otherlsoptionsandhelp3" src="https://github.com/user-attachments/assets/02242a74-4d88-46d1-8b56-657c277b16b3" />

<img width="600" height="600" alt="06-lesson1-otherlsoptionsandhelp4" src="https://github.com/user-attachments/assets/3a92fb5e-f179-4c28-98ee-8ae40d754837" />



### Lesson 1 Quiz

<img width="600" height="600" alt="lesson1quiz" src="https://github.com/user-attachments/assets/f36d2d77-c81f-4c46-b521-a8224d0f5c9c" />

<img width="600" height="600" alt="lesson1quiz2" src="https://github.com/user-attachments/assets/c37e11ea-c522-4564-92d0-7c2085ef30df" />

<img width="600" height="600" alt="lesson1quiz3" src="https://github.com/user-attachments/assets/673570a0-b318-4a18-816c-34f11c782d29" />

### Lesson 2

<img width="600" height="600" alt="02-lesson2-mancommand" src="https://github.com/user-attachments/assets/575447aa-ed0d-42d0-9c3a-ddd701f1d6cd" />

<img width="600" height="600" alt="02-lesson2-manintro" src="https://github.com/user-attachments/assets/10ba35d8-7a5a-44b6-8345-09be1142c51e" />

### Lesson 3

<img width="600" height="600" alt="03-lesson3-createdirectories" src="https://github.com/user-attachments/assets/1fe7d799-8634-4caa-a723-c7fcf4329c87" />

<img width="600" height="600" alt="03-lesson3-createdirectories2" src="https://github.com/user-attachments/assets/f5f4298d-354f-42c4-b006-8d6544a79922" />

<img width="600" height="600" alt="03-lesson3-navigatingdirectories" src="https://github.com/user-attachments/assets/cc323605-0da6-48ba-a5ec-c5249057f58b" />

<img width="600" height="600" alt="03-lesson3-navigatingdirectories2" src="https://github.com/user-attachments/assets/be4d54a5-0a54-4bf2-b5d1-d1fc04d07959" />

<img width="600" height="600" alt="03-lesson3-navigatingtorootdirectory" src="https://github.com/user-attachments/assets/b0afd77f-d2d6-4b07-8ff6-69801379d12c" />

<img width="600" height="600" alt="03-lesson3-deletingdirectories" src="https://github.com/user-attachments/assets/52b9e09a-fbf7-4d3d-b91c-907b1cd60168" />

### Lesson 3 Quiz

<img width="600" height="600" alt="lesson3quiz" src="https://github.com/user-attachments/assets/4eca6e60-1091-4906-b8db-809165bf0c32" />

<img width="600" height="600" alt="lesson3quiz1" src="https://github.com/user-attachments/assets/bc1e17a5-419b-42cb-89a1-6d64a9e6f70b" />

<img width="600" height="600" alt="lesson3quiz2" src="https://github.com/user-attachments/assets/1782c8c7-3746-4f67-bcab-7e8a9bd54550" />

### Lesson 4

<img width="600" height="600" alt="04-lesson4-creatingfiles" src="https://github.com/user-attachments/assets/49db88d0-b7fc-4ff5-81da-5375beace3d1" />

<img width="600" height="600" alt="04-lesson4-deletingfiles" src="https://github.com/user-attachments/assets/d4089857-fa61-41af-b7eb-69df8bee9a61" />

<img width="600" height="600" alt="04-lesson4-vimcreatefile" src="https://github.com/user-attachments/assets/84204702-db6f-4dde-844a-3e7f35e3248e" />

### Lesson 5

<img width="600" height="600" alt="05-lesson5-pipes" src="https://github.com/user-attachments/assets/db92eb59-f624-4e1d-bc39-4d3f709915bf" />

<img width="600" height="600" alt="05-lesson5-pipes-redirectfiles" src="https://github.com/user-attachments/assets/6f5dc4ca-e263-4a38-b82e-abe67fcedcab" />

<img width="600" height="600" alt="05-lesson5-pipes-inputredirection" src="https://github.com/user-attachments/assets/123e97f4-8e5d-4c60-8132-3278de7d246b" />

### Lesson 5 Quiz

<img width="600" height="600" alt="lesson5quiz" src="https://github.com/user-attachments/assets/fe7c796a-d91e-467d-ae5b-b017569082e4" />

<img width="600" height="600" alt="lesson5quiz2" src="https://github.com/user-attachments/assets/c1f4e9be-7e8f-432e-b4a0-992d4c84201a" />

<img width="600" height="600" alt="lesson5quiz3" src="https://github.com/user-attachments/assets/c6820f21-396f-43ca-bdbd-4f5572efc22e" />

### Lesson 6

<img width="600" height="600" alt="06-lesson6-catandvim" src="https://github.com/user-attachments/assets/2b618ea8-3478-40c5-8790-1d1dd75bb0a8" />

<img width="600" height="600" alt="06-lesson6-readlessandmore" src="https://github.com/user-attachments/assets/9031d105-5fb6-48a9-8a9b-3631179f2ba5" />

<img width="600" height="600" alt="06-lesson6-printpartfile" src="https://github.com/user-attachments/assets/83c923d2-c005-41e8-94a2-29ed99b975bf" />

<img width="600" height="600" alt="06-lesson6-printpartfile2" src="https://github.com/user-attachments/assets/0388ac24-5359-40c3-ae0c-8165ab10ab7a" />

### Lesson 6 Quiz

<img width="600" height="600" alt="lesson6quiz" src="https://github.com/user-attachments/assets/6a49f3ea-69b8-40d5-80e1-c7ba6d4c4093" />

<img width="600" height="600" alt="lesson6quiz2" src="https://github.com/user-attachments/assets/faa0f8f0-096b-4e3c-8c07-cf530f6cd958" />

### Lesson 7

<img width="600" height="600" alt="07-lesson7-copyandmovefiles" src="https://github.com/user-attachments/assets/a68872cd-ceb6-400d-a8a7-d52d92f23dfb" />

<img width="600" height="600" alt="07-lesson7-copyandmovefiles2" src="https://github.com/user-attachments/assets/1f8850bf-ce01-4e1c-b8ab-42958a280bc9" />

<img width="600" height="600" alt="07-lesson7-copyandmovefiles3" src="https://github.com/user-attachments/assets/5e24f85b-e213-4b31-b9df-666945248eba" />

<img width="600" height="600" alt="07-lesson7-copyandmovefiles4" src="https://github.com/user-attachments/assets/425df99b-6497-4c3b-a01a-1c88568ba3c1" />

<img width="600" height="600" alt="07-lesson7-copyandmovefiles5" src="https://github.com/user-attachments/assets/c60b3f4d-f41a-489b-9342-0a4e0c21faf1" />

<img width="600" height="600" alt="07-lesson7-copyandmovefiles6" src="https://github.com/user-attachments/assets/ff17980b-32e2-459e-997e-4dcdb165616a" />

### Lesson 8

<img width="600" height="600" alt="08-lesson8-topcommand" src="https://github.com/user-attachments/assets/cafaad44-d128-4e47-bd5c-c0dcf6fa4616" />

<img width="600" height="600" alt="08-lesson8-modifydefaultview" src="https://github.com/user-attachments/assets/8025ed9a-60f7-4d13-b574-a5483de12fba" />



**Git**:
Learning Git (megafile) == Chapters 1-3
Git Fundamentals (killercoda.com) = Lessons 1-4 ✅

### Lesson 1

<img width="600" height="600" alt="01-lesson1-checkpackages" src="https://github.com/user-attachments/assets/58676692-3c4d-4cfb-a0e9-16fe9a07bdf8" />

<img width="600" height="600" alt="01-lesson1-installgit" src="https://github.com/user-attachments/assets/9dc52498-6b1f-4a43-9fe6-a6e37cad095b" />

<img width="600" height="600" alt="01-lesson1-isgitinstalled" src="https://github.com/user-attachments/assets/aadddc74-a06f-43c3-8fdd-21f236c589aa" />

### Lesson 2

<img width="600" height="600" alt="01-lesson2-configuregit" src="https://github.com/user-attachments/assets/1f0f6452-3775-43a5-882e-179b1ddd2594" />

<img width="600" height="600" alt="01-lesson2-gitdirectorystructure" src="https://github.com/user-attachments/assets/2f13e5c0-bff9-4b49-a19e-2f34ffa3eb45" />

<img width="600" height="600" alt="01-lesson2-gitconfigexamples" src="https://github.com/user-attachments/assets/6cb1b5be-f73d-452b-b8e9-af3726370766" />

### Lesson 3

<img width="600" height="600" alt="01-lesson3-initializerepo" src="https://github.com/user-attachments/assets/f7f169cd-4abd-4055-95e1-ac58a7d8a913" />

<img width="600" height="600" alt="01-lesson3-repostatus" src="https://github.com/user-attachments/assets/75fadf5e-5b76-4910-a5aa-16460b00c1e5" />

<img width="600" height="600" alt="01-lesson3-addfiles" src="https://github.com/user-attachments/assets/fe83e3ed-f079-4cbe-9f1b-5bbd99c4d42c" />

<img width="600" height="600" alt="01-lesson3-commitfiles" src="https://github.com/user-attachments/assets/a263308e-4eef-4597-a524-99502b5fffa7" />

<img width="600" height="600" alt="01-lesson3-addandcommitmultiplefiles" src="https://github.com/user-attachments/assets/ea47fb22-44ae-4423-a64e-463840364955" />

### Lesson 4

<img width="600" height="600" alt="01-lesson4-removefilesfromstage" src="https://github.com/user-attachments/assets/913fc4f3-c58b-4a9a-b8cc-a661fa288aee" />

<img width="600" height="600" alt="01-lesson4-previousstate" src="https://github.com/user-attachments/assets/229738b1-867d-4727-b17c-f8cd8501ced5" />

<img width="600" height="600" alt="01-lesson4-removefilefromcommit" src="https://github.com/user-attachments/assets/bfdff8e6-ecfb-4628-82ba-65c3c9b7f753" />














### "Class Practice"

Re-run the in-class lab from Friday and Saturday’s recordings, taking screenshots along the way. Take a screenshot of every step in the Terraform IVPAD sequence, showing the resulting output of each command. After running terraform destroy, and confirming resources have been torn down in GCP, run the following command within quotation marks in Git Bash for Windows, or Terminal for Mac/Linux: “date && hostename && whoami”


### Deliverables

Screenshots:

`terraform init`

<img width="600" height="600" alt="01terraforminit" src="https://github.com/user-attachments/assets/167faa29-99f8-4f46-98a8-aeaee3fbfdf9" />



`terraform validate`

<img width="600" height="600" alt="02terraformvalidate" src="https://github.com/user-attachments/assets/5b41affe-f767-4cf1-a5dc-3e99006e3d88" />


`terraform plan`

<img width="600" height="600" alt="03terraformplan" src="https://github.com/user-attachments/assets/547406ba-5284-4566-8cbe-82b7130a1427" />


`terraform apply`

<img width="600" height="600" alt="04terraformapplyyes" src="https://github.com/user-attachments/assets/83e33556-62ae-40b8-805a-2b155c85f4a2" />

**SUCCESS**<br/>

<img width="600" height="600" alt="05terraformapplysuccess" src="https://github.com/user-attachments/assets/f51e1779-f88d-4177-836c-3ba24152224b" />

**Created Resources in Google Cloud Platform**<br/>

<img width="600" height="600" alt="06gcpcreatedresources" src="https://github.com/user-attachments/assets/d69e95b8-ba4a-4c0f-9880-dc1251ed59a0" />

`Terraform destroy`

<img width="600" height="600" alt="07terraformdestroy" src="https://github.com/user-attachments/assets/255c135f-6ad8-4bf0-8931-63acd2a78550" />

**Deleted Resources in Google Cloud Platform**<br/>

<img width="600" height="600" alt="08gcpdestroyedresources" src="https://github.com/user-attachments/assets/b3a61e5e-9134-4717-a958-a4d9c9ae737c" />


`Date && hostename && whoami`

<img width="600" height="600" alt="09extracommands" src="https://github.com/user-attachments/assets/ab904843-25b9-4af1-b737-6d3e594112f6" />



## Be A Man Extra Credit:

Using the Terraform files from this week's classes, export what's described when "Terraform plan" is run into a file. Then, create a new folder in Terminal/Git Bash titled "<insertDateHere>_weekB_hw", go into that folder, and move the Terraform Plan output into that folder. Finally, use Git to push the Terraform plan output to GitHub. Your group leader will share/show how to create a GitHub repository. The GitHub repository must start with “TheoU_7.5_BaM_weekB”.


### Deliverables:
Screenshots
Above screenshots
**Terraform Plan output, in a .txt or .json format**


[Student’s GitHub repo link](url)



