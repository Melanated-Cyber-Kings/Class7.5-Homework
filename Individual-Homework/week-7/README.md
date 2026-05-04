# gcs_static_website

The purpose of this task is to host a static website on GCS using a storag bucket. The benefit of this is it allows the creation of static websites on GCS without the use of compute engine, making this have minimal cost. However, a setback is that dynamic websites are unable to be gererated this way. The most important aspects learned from this endeavor are the difference between static websites in GCS do not need to have a cdn defined and attatched for it to work unlike in AWS. Also, the Owner role attached to the service account used by terraform to interact with your account is not enough permissions to build this; you must add the storage Admin role as well.

The documents used were:

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam#google_storage_bucket_iam_member-1

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object

https://docs.cloud.google.com/storage/docs/access-control/iam

https://docs.cloud.google.com/iam/docs/roles-permissions?_gl=1*gfbihj*_ga*MTEzNzU4MDk2NS4xNzMxNTA4MzE2*_ga_WH2QY8WWF5*czE3Nzc2NjA4OTgkbzQyJGcxJHQxNzc3NjYzOTI3JGo5JGwwJGgw
