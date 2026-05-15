## Q & A:

    Q1 - What is the difference between high availability and fault tolerance? Which is best to strive for?
    A1 - High availability is a term that refers to a system being accessible and reliable close to 100% of the time. Fault tolerance is a term that refers to a system being able to operate continuously after one or more of its critical components fail. Where high availability and fault tolerance differ is in the way downtime of system is treated (respectively). With high availability, the goal is for the system to experience as little downtime as possible. With fault tolerance, the goal is for the system to experience zero downtime. Everyone aims for perfection, so it's best to strive for fault tolerance within a system.
    
    Resource/Documentation/Reference - https://www.ibm.com/think/topics/high-availability
    How Resource/Documentation/Reference was used - Leveraged the content under "What is high availability?" and "HA versus fault tolerance"


    Q2 - Explain the difference between autoscaling and elasticity. What is vertical and horizontal autoscaling? Is one better? Are they feasible on prem?
    A2 - Auto-scaling refers to the automatic adjustment of compute resources to meet shifting workload demands, while elasticity is a system’s ability to scale resources up or down efficiently in response to those demand changes. Vertical autoscaling is a system automatically increasing or decreasing the capacity of a resource, while horizontal autoscaling is adding or removing a resource(s). Horizontal autoscaling tends to be better in cloud environments due to the following reasons: 1. Vertical autoscaling often requires temporarily interrupting the running system, so it is less commonly automated, 2. Horizontal autoscaling adds or removes instances while keeping the service running though not always with zero operational impact, and 3. Major cloud providers such as GCP, AWS, and Azure all support automatic horizontal scaling. Applying vertical and horizontal autoscaling within an on-prem environment is not feasible for the following reasons: 1. Scaling is constrained by physical hardware, 2. Capacity often must be over-provisioned for peak demand, and 3. Adding resources can require manual procurement, configuration, or downtime

    Resource/Documentation/Reference - 1. https://tenmilesquare.com/capabilities/scalability-architecture/auto-scaling-and-elasticity/ and 2. https://aerospike.com/blog/cloud-scalability-explained/
    How Resource/Documentation/Reference was used - (Link 1) => Leveraged the content under "What are Auto-Scaling and Elasticity?" and (Link 2) => Leveraged the content under "Public vs. private cloud scalability"


    Q3 - Explain what the difference between managed and unmanaged instance groups is.
    A3 - First, let's establish that an instance group is a collection of virtual machine (VM) instances that you can manage as a single entity and that GCP Compute Engine offers two kinds of VM instance groups, managed and unmanaged. Managed instance groups (MIGs) let you operate apps on multiple identical VMs. You can make your workloads scalable and highly available by taking advantage of automated MIG services, including: autoscaling, autohealing, regional (multiple zone) deployment, and automatic updating. Unmanaged instance groups (UIGs) let you load balance across a fleet of VMs that you manage yourself. 

    Resource/Documentation/Reference - https://docs.cloud.google.com/compute/docs/instance-groups
    How Resource/Documentation/Reference was used - Leveraged the beginning portion of the doc before "Try it for yourself"


    Q4 - Explain the different use cases for health checks used by applications (in instance groups) and health checks used by load balancers. Can they be the same? Are they different API calls? Should they be the same?
    A4 - Application-based health checks monitor whether an application responds as expected on each VM. If the application freezes, crashes, becomes unresponsive, or runs out of memory, the managed instance group can detect the failure and automatically recreate the VM to restore service. Load balancer-based health checks help direct traffic away from non-responsive instances and toward healthy instances; these health checks do not cause the Google Compute Engine service to recreate instances. The health checks used to monitor applications are similar to the health checks used for load balancing, with some differences in behavior. The API calls for Application-based health checks and Load balancer-based health checks are the same (healthChecks)

    Resource/Documentation/Reference - 1. https://docs.cloud.google.com/compute/docs/instance-groups and 2. https://docs.cloud.google.com/compute/docs/reference/rest/v1/healthChecks
    How Resource/Documentation/Reference was used - (Link 1) => Leveraged the content under "Automatic repair and autohealing" and "Health checking" AND (Link 2) => Leveraged the content under "Resource: HealthCheck"


    Q5 - Explain in a few sentences what the 3 tier architecture is and how it relates to what you are learning.
    A1 - A 3 tier architecture is a way to design apps that separates the app into 3 main parts. The first part is the presentation tier that allows users to interact with the GUI. Next, we have the logic tier that has the main part of written in some programming language. Finally, we have the data tier that has the database and other data storage. The web and logic tiers are essentially the same except for the fact that the logic tiers leverages an internal load balancer.  

    Resource/Documentation/Reference - 1. https://docs.cloud.google.com/load-balancing/docs/application-load-balancer#three-tier_web_services and 2. https://www.ibm.com/think/topics/three-tier-architecture
    How Resource/Documentation/Reference was used - (Link 1) => Leveraged the content under "Use cases" and "Health checking" AND (Link 2) => Leveraged the content under "The three tiers in detail"



## Runbook:
    End Goal:
    A fully configured MIG with autohealing and autoscaling created via the GCP console. Estimated TIme is 10-15 minutes

    Prerequisites:
    - GCP account access with proper permissions
    - Instance Template
    - Health check config
    - Compute Engine API Enabled

    Follow these Steps:
    - Go to the GCP Console
        1. Navigate to the GCP Compute Engine
        2. Go to Instance Groups in navigation menu
        3. Click on "Create Instance Group"
    - Ensure the instance group is a "Managed Instance Group (Stateless)"
    - Make sure the instance group has a name that contains the team name and date
    - Add an informative description
    - Choose the correct instance template
    - Do not set the number of instances (the MIG autoscaler will handle this)
    - Under "Location" (verify that the instance group will manage instances across multiple zones)
        * ensure "multiple zones" is selected
        * choose at least 3 zones (per company policy)
    - Under "Autoscaling" (How to enable autoscaling)
        * click "Configure Autoscaling"
        * minimum should be the same as the amount of zones
        * maximum will be determined by team needs
        * autoscaling signals can typically be CPU but developers should supply this
    - Under "autohealing" (How to enable autohealing)
        * select one of the existing health check configurations
        * initial delay needs to be *at least* the amount of time it takes for app to bootstrap entirely
        * default action should be "repair instance"
    - Click Create



## Terraform (see next 5 headings):

## 1. Required arguments for VM

- boot_disk
- machine_type
- name
- network_interface

Sources: 

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#argument-reference

## 2. How to get Internal and External IP Address output

```terraform
output "vm_external_ip" {
    description = "External IP address of the instance"
    value       = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
```

```terraform
output "vm_internal_ip" {
    description = "Internal IP address of the instance"
    value       = google_compute_instance.default.network_interface.0.network_ip 
}
```

Sources:

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#attributes-reference (Under Attributes References)

https://www.reddit.com/r/Terraform/comments/rd8mx0/how_to_get_external_ip_address_that_google_cloud/ (under the response from reddit user v1tal3)

## 3. Two Non-required VM arguments

- description: This attribute provides a short description of the associated resource (in this case a vm) that is being provisioned
- desired_status: This attribute let's you determine the desired status of your vm by defining one of the following options: "RUNNING", "SUSPENDED", or "TERMINATED"

Sources:

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#description-1

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#desired_status-1

## 4. Format to create a VM based off the centOS stream 10 image

Do the following in order to figure out the correct format for creating a VM with the “centOS stream 10” image:
1. Go into the GCP console
2. Search VM instances
3. Click Create instance
4. Click on OS and storage
5. Click "Change" under Operating system and storage
6. Select the following values => Operating system = CentOS, Version = CentOS Stream 10 (for x86/64), Boot disk type = Balanced persistent disk, Size (GB) = 100
7. Click Select
8. Click Equivalent code
9. Click Terraform
10. The format for creating a VM with the “centOS stream 10” image can be found in the initialize_params block via the image argument (see snippet below)

```terraform
  boot_disk {
    auto_delete = true
    device_name = "instance-20260514-202313"

    initialize_params {
      image = "projects/centos-cloud/global/images/centos-stream-10-v20260513"
      size  = 100
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }
```
Sources: 

https://docs.cloud.google.com/compute/docs/images 

https://stackoverflow.com/questions/53224230/list-all-available-public-images-with-gcloud-apis

https://docs.cloud.google.com/compute/docs/images/os-details

https://docs.cloud.google.com/compute/docs/machine-resource

## 5. Difference between name argument, id attribute, self_link attribute

- name: This argument provides a distinct and unique name for the vm instance

- id: This attribute provides a unique identifier for the vm instance via the following format: projects/{{project}}/zones/{{zone}}/instances/{{name}}

- self_link: This attribute provides the Uniform Resource Identifier (URI) for the vm instance

Arguments in Terraform are what is set in your .tf files (e.g., name). Attributes are data Terraform learns from a resource after it is created (e.g., id and self_link)

Sources:

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#name-1

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#id-1

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#self_link-1

https://medium.com/@udarasenarath/resource-attributes-dependencies-why-terraform-orders-things-and-how-to-control-it-f0a05795033a