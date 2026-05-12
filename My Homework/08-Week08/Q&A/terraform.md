# Creating a VM Using Terraform

## Mandatory Arguments

- `boot_disk`: This defines the disk that will boot the OS for your instance
- `machine_type`: The machine type for your instance. [Machine families](https://docs.cloud.google.com/compute/docs/machine-resource)
- `name`: The name of your resource. This name needs to be unique

## Additional Arguments

- `metadata`: These are key value pairs that provide custom supplemental information about your instance. The metadata can be accessed by using the header "Metadata-Flavor". For example: `curl http://metadata.google.internal/computeMetadata/v1 -H 'Metadata-Flavor: Google' or by running the following gcloud command `gcloud compute instances describe {instance name} --format='value(metadata.items.YOUR_KEY)'`
- `delete_protection`: As long as this is turned on, the instance cannot be deleted.

## Outputing Instance Details

Terraform allows you to output any attributes defined for the resources. To output external and internal IP you'd use the attributes network_interface.0.access_config.0.nat_ip and network_interface.0.network_ip respectively.

## Determining What Value to Use for Image (boot_disk -> initialization_params -> image)

You can see the `gcloud` command for any action that you do in the GCP console. The easiest way to find out what image to use is to start creating a VM and configuring the boot disk in the console. Instead of completing the creation of the image, look at the `gcloud` command and search for `--create-disk`. In this section you'll find the image that was used.


## Understanding the Difference Between Name, ID and self_link

Name is the unique name that you assign to the instance, ID is the identifier for the resource that GCP creates (this will be in a specific format) and self_link is the URI of the resource (this is unique to the resource).