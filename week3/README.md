## Week 3

### "Udemy GCP MasterClass: Section 10"

**LAB: VPC IPs Distribution**

I've created two external static IP addresses, one is regional and the other is a global static IP address.<br/>

<img width="600" height="600" alt="01-externalstaticips" src="https://github.com/user-attachments/assets/66c96162-11ce-42a5-9d72-94a0e2dc0548" />

In this diagram, I've created three VM instances. One has no external IP address, one has an external IP address, and the third one has a static IP address assigned to it.

<img width="600" height="600" alt="02-staticipsassignedtovm" src="https://github.com/user-attachments/assets/6a6aa09c-0599-443b-a539-128f2896a361" />
<br/>
<br/>

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
<br/>
<br/>

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
<br/>
<br/>

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
<br/>
<br/>

**LAB: Cloud Routers for Routing in GCP**

Create custom VPC<br/>

<img width="600" height="600" alt="64-createcustomvpc" src="https://github.com/user-attachments/assets/ca0f80d0-30a5-4cec-be10-85c92bdace88" />

Create another custom VPC for uswest-1<br/>

<img width="600" height="600" alt="65-createanothercustomvpcinuswest1" src="https://github.com/user-attachments/assets/fcdc0bd5-9c73-4047-9b0a-88e0dd03021e" />

Create Firewall Rule for VPC1<br/>

<img width="600" height="600" alt="66-createfirewallruleforvpc1" src="https://github.com/user-attachments/assets/56c6341a-22b9-4f4b-973c-885ee316f7f7" />

Firewall Rule Ports for VPC1<br/>

<img width="600" height="600" alt="67-createfirewallruleforvpc1part2" src="https://github.com/user-attachments/assets/8996b3f9-ac58-46cd-9764-1b74dfb14aa4" />

Create a Firewall Rule for VPC2<br/>

<img width="600" height="600" alt="68-createfirewallruleforvpc2" src="https://github.com/user-attachments/assets/7bd22c4a-f808-44d1-b8df-cf364a3f1eac" />

Firewall Rule Ports for VPC2<br/>

<img width="600" height="600" alt="69-createfirewallruleforvpc2part2" src="https://github.com/user-attachments/assets/fe765dee-3184-437c-a288-abea38b8082c" />

Create VM Instance for VPC1<br/>

<img width="600" height="600" alt="70-createvminstanceforvpc1" src="https://github.com/user-attachments/assets/2d26da84-009f-4b31-bf5a-14289d116eb4" />

Assign VPC1 Network to VM Instance 1

<img width="600" height="600" alt="71-assignvpc1tovminstance" src="https://github.com/user-attachments/assets/f49a3fbf-d705-4fa2-88e1-1c9b4fb8c777" />

Create VM Instance for VPC2<br/>

<img width="600" height="600" alt="72-createvminstanceforvpc2uswest1" src="https://github.com/user-attachments/assets/f2af61bb-11f5-4973-b962-fcc7cbd160cd" />

Assign VPC2 Network to VM Instance 2<br/>

<img width="600" height="600" alt="73-assignvpc2tovminstance2" src="https://github.com/user-attachments/assets/d90f9e70-650c-4084-9899-fdf92f1d3d04" />

SSH on VM1<br/>

<img width="600" height="600" alt="74-sshonvm1" src="https://github.com/user-attachments/assets/7c8a69a4-b1ce-428e-8df5-3a74cae79b9b" />

Ping to External IP Address on VM2<br/>

<img width="600" height="600" alt="75-pingtoexternaliponvm2" src="https://github.com/user-attachments/assets/2314ac37-ca6f-44fa-b030-80560f1d8faf" />

Ping to Internal IP Address on VM2<br/>

<img width="600" height="600" alt="76-pinginternaliponvm2" src="https://github.com/user-attachments/assets/6f2547ee-3185-4c08-8fc0-27a39993d83c" />

SSH to VM2 & Ping to External IP Address on VM1<br/>

<img width="600" height="600" alt="77-pingexternaliponvm1" src="https://github.com/user-attachments/assets/37d781e0-fadf-47c2-8acb-16b758749d83" />

Ping to Internal IP Address on VM1<br/>

<img width="600" height="600" alt="78-pingtointernaliponvm1" src="https://github.com/user-attachments/assets/d4b5621a-1e07-4203-8e3a-c9800529c6aa" />

Create Cloud Router<br/>

<img width="600" height="600" alt="79-createcloudrouter1" src="https://github.com/user-attachments/assets/c004bf71-414e-4f3c-97c6-892c82812a6b" />

Create Cloud Router 2<br/>

<img width="600" height="600" alt="80-createcloudrouter2" src="https://github.com/user-attachments/assets/566df4ed-fa40-4052-bd86-0581be0fde30" />

Reserve Static IP Address<br/>

<img width="600" height="600" alt="81-reservestaticipaddress" src="https://github.com/user-attachments/assets/521c98e8-5870-480d-8a25-eb85c52c343e" />

Reserve Static IP Address 2<br/>

<img width="600" height="600" alt="82-reservestaticipaddress2" src="https://github.com/user-attachments/assets/d023a738-e92d-403c-bf6c-403ca6a53935" />

Create Classic VPN<br/>

<img width="600" height="600" alt="83-createclassicvpn" src="https://github.com/user-attachments/assets/7c043f11-e549-4bb3-9024-149383d63fc0" />
<br/>
<br/>
<br/>

### "Udemy GCP Security Engineer: Section 13"

**HANDS-ON: Explore Default VPC**



**HANDS-ON: Create Auto Mode VPC**

**HANDS-ON: Create Custom Mode VPC**

**HANDS-ON: Create Virtual Machine w/ all subnets**

**HANDS-ON: Create Firewall Rule - SSH**

**HANDS-ON: Internal vs External IP Address**

**HANDS-ON: Static vs Ephermeral IP Address**
<br/>
<br/>