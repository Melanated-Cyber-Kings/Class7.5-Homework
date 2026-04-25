# References

!!!!EDIT THIS ENTIRE README.md FILE!!!!!

YOU WILL BE DOING THE SAME LAB AS 02-WEEKe-02 BUT THIS TIME VIA TERRAFORM

- https://github.com/BalericaAI/SEIR-1/tree/main/weekly_lessons/weeka
- https://github.com/BalericaAI/SEIR-1/blob/main/weekly_lessons/weekb/weekb_homework.txt

# ☁️ SEIR‑I — Week 3 (GCP VM Deployment & Grading)

Hands‑on cloud engineering practice using Google Cloud Platform (GCP).
This repository contains the deliverables, terraform files, verification artifacts, and grading outputs for SEIR‑I Week 3. This lab is focused on deploying a Compute Engine VM with an automated startup script via terraform and validating service correctness.

## Repository Purpose

This project is intended to:

- Deploy a GCP VM using a provided startup script via terraform
- Serve a custom homepage, health endpoint, and metadata endpoint
- Validate the deployment using an automated grading script

## Lab Overview — Week 3

The Week 3 lab introduces foundational cloud engineering concepts:

- Creating a Compute Engine VM in GCP via terraform
- Using a startup script to automate configuration of that VM via terraform
- Serving HTTP endpoints (`/`, `/healthz`, `/metadata`)
- Verifying service health and metadata correctness
- Running an automated grading script
- Producing confirmation artifacts from the grading script (e.g., `badge.txt` and `gate_result.json`)

This mirrors real‑world cloud engineering workflows: automation, infrastructure as code, validation, and reproducibility.

## Prerequisites

- Terraform installed on the local machine
- Authentication configured via glcoud init on the local terminal
- Google Cloud Platform account
- Billing enabled (free tier is sufficient)
- Compute Engine API enabled
- Google Cloud Shell or local terminal with curl (curl --version) and jq (jq --version)
- Provided startup script (supera.sh)
- Provided grading script (gate_gcp_vm_http_ok.sh)

## VM Deployment Instructions

Follow steps 1-13 to deploy the Compute Engine VM in GCP via terraform

### 1. Create the VM

Login to your GCP account and select your desired project (Note, ensure you select the same project that is configured within gcloud init)

Click on the Navigation Menu to the left then navigate to Compute Engine → VM Instances

Within the VM instances menu click "Create Instance"

Enter/Select the following under Machine configuration:

Name: week-3-node
Region: us-central1 (any region is fine for this lab)
Zone: Any
Select E2
Machine type: e2-medium

Enter/Select the following under Data protection:

No backups

Enter/Select the following under Networking:

Allow HTTP traffic

### 2. Add the Startup Script

Under Advanced, scroll to Automation → Startup script

Copy and Paste the content within supera.sh (https://github.com/BalericaAI/SEIR-1/blob/main/weekly_lessons/weeka/userscripts/supera.sh) into the Startup script text field

### 3. Add Metadata

Staying within Advanced, scroll down to Metadata

Click Add item and enter the following values:

Key 1: student_name
Value: Your Name

DO NOT CLICK CREATE, you will come back to this page later

### 4. Create 0-auth.tf

Within your local terminal, go into your parent directory for the week 3 Lab and create a terraform folder via the following command ➡️ mkdir terraform

Change directory into the newly created terraform folder via the following command ➡️ cd terraform

Create 0-auth.tf in the terraform folder via the following command ➡️ touch 0-auth.tf

### 5. Create 1-vm.tf

Create 1-vm.tf in the terraform folder via the following command ➡️ touch 1-vm.tf

### 6. Go into vsCode

Open vsCode from the current terminal session via the following command ➡️ code .

### 7. Logic for 0-auth.tf

Within vsCode, click on 0-auth.tf and copy/paste the following terraform logic into it:

```
# Authenticate to GCP

# Ensure Google Cloud CLI is set in the terminal via gcloud init

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "class75-michaelanunda" # Replace this line with your specific project that is configured to your gcloud init
  region  = "us-central1" # Replace this line with the specific region you want to deploy infrastructure to
}

```

### 8. Copy terraform logic for vm via the GCP GUI

Go back to the GCP GUI (see Step 3 above) and click Equivalent code at the bottom

Within the Equivalent code menu to the right, click Terraform then click Copy

Paste this terraform logic within 

### 9. Logic for 1-vm.tf

Within vsCode, click on 1-vm.tf and paste the terraform logic from Step 8 into it:

```
# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "week-3-node" {
  boot_disk {
    auto_delete = true
    device_name = "week-3-node"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20260417"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src           = "vm_add-tf"
    goog-ops-agent-policy = "v2-template-1-7-0"
  }

  machine_type = "e2-medium"

  metadata = {
    enable-osconfig = "TRUE"
    startup-script  = "#!/bin/bash\nset -euo pipefail\n\n#Chewbacca: The node awakens. And it will speak in HTML, plain text, and JSON.\n\n#Thanks for Aaron!\nsleep 5\napt update -y\napt install -y nginx curl jq\n\nMETADATA=\"http://metadata.google.internal/computeMetadata/v1\"\nHDR=\"Metadata-Flavor: Google\"\nmd() { curl -fsS -H \"$HDR\" \"$${METADATA}/$1\" || echo \"unknown\"; }\n\nINSTANCE_NAME=\"$(md instance/name)\"\nHOSTNAME=\"$(hostname)\"\nPROJECT_ID=\"$(md project/project-id)\"\nZONE_FULL=\"$(md instance/zone)\"                  # projects/<id>/zones/us-central1-a\nZONE=\"$${ZONE_FULL##*/}\"\nREGION=\"$${ZONE%-*}\"\nMACHINE_TYPE_FULL=\"$(md instance/machine-type)\"\nMACHINE_TYPE=\"$${MACHINE_TYPE_FULL##*/}\"\n\nINTERNAL_IP=\"$(md instance/network-interfaces/0/ip)\"\nEXTERNAL_IP=\"$(md instance/network-interfaces/0/access-configs/0/external-ip)\"\nVPC_FULL=\"$(md instance/network-interfaces/0/network)\"\nSUBNET_FULL=\"$(md instance/network-interfaces/0/subnetwork)\"\nVPC=\"$${VPC_FULL##*/}\"\nSUBNET=\"$${SUBNET_FULL##*/}\"\n\nSTART_TIME_UTC=\"$(date -u +\"%Y-%m-%dT%H:%M:%SZ\")\"\n\n# --- Student banner ---\n# Students set this when creating the VM by adding a metadata key:\n#   student_name = Darth Malgus Jr\nSTUDENT_NAME=\"$(md instance/attributes/student_name)\"\n[[ -z \"$STUDENT_NAME\" || \"$STUDENT_NAME\" == \"unknown\" ]] && STUDENT_NAME=\"Anonymous Padawan (temporarily)\"\n\n# --- Basic system stats ---\nUPTIME=\"$(uptime -p || true)\"\nLOADAVG=\"$(awk '{print $1\" \"$2\" \"$3}' /proc/loadavg 2>/dev/null || echo \"unknown\")\"\n\nMEM_TOTAL_MB=\"$(free -m | awk '/Mem:/ {print $2}')\"\nMEM_USED_MB=\"$(free -m | awk '/Mem:/ {print $3}')\"\nMEM_FREE_MB=\"$(free -m | awk '/Mem:/ {print $4}')\"\n\nDISK_LINE=\"$(df -h / | tail -n 1)\"\nDISK_SIZE=\"$(echo \"$DISK_LINE\" | awk '{print $2}')\"\nDISK_USED=\"$(echo \"$DISK_LINE\" | awk '{print $3}')\"\nDISK_AVAIL=\"$(echo \"$DISK_LINE\" | awk '{print $4}')\"\nDISK_USEP=\"$(echo \"$DISK_LINE\" | awk '{print $5}')\"\n\n# --- Nginx config: add endpoints /healthz and /metadata ---\ncat > /etc/nginx/sites-available/default <<'EOF'\nserver {\n    listen 80 default_server;\n    listen [::]:80 default_server;\n\n    root /var/www/html;\n    index index.html;\n\n    #Chewbacca: The homepage is for humans.\n    location = / {\n        try_files /index.html =404;\n    }\n\n    #Chewbacca: Health checks are for machines. Keep it boring.\n    location = /healthz {\n        default_type text/plain;\n        return 200 \"ok\\n\";\n    }\n\n    #Chewbacca: Metadata is for engineers and scripts.\n    location = /metadata {\n        default_type application/json;\n        try_files /metadata.json =404;\n    }\n}\nEOF\n\n# --- Write JSON endpoint file ---\ncat > /var/www/html/metadata.json <<EOF\n{\n  \"service\": \"seir-i-node\",\n  \"student_name\": \"$(echo \"$STUDENT_NAME\" | sed 's/\"/\\\\\"/g')\",\n  \"project_id\": \"$PROJECT_ID\",\n  \"instance_name\": \"$INSTANCE_NAME\",\n  \"hostname\": \"$HOSTNAME\",\n  \"region\": \"$REGION\",\n  \"zone\": \"$ZONE\",\n  \"machine_type\": \"$MACHINE_TYPE\",\n  \"network\": {\n    \"vpc\": \"$VPC\",\n    \"subnet\": \"$SUBNET\",\n    \"internal_ip\": \"$INTERNAL_IP\",\n    \"external_ip\": \"$EXTERNAL_IP\"\n  },\n  \"health\": {\n    \"uptime\": \"$UPTIME\",\n    \"load_avg\": \"$LOADAVG\",\n    \"ram_mb\": {\"used\": $MEM_USED_MB, \"free\": $MEM_FREE_MB, \"total\": $MEM_TOTAL_MB},\n    \"disk_root\": {\"size\": \"$DISK_SIZE\", \"used\": \"$DISK_USED\", \"avail\": \"$DISK_AVAIL\", \"use_pct\": \"$DISK_USEP\"}\n  },\n  \"startup_utc\": \"$START_TIME_UTC\"\n}\nEOF\n\n# --- Write the main HTML dashboard ---\ncat > /var/www/html/index.html <<EOF\n<!DOCTYPE html>\n<html>\n<head>\n  <meta charset=\"utf-8\"/>\n  <title>SEIR-I Ops Panel</title>\n  <meta http-equiv=\"refresh\" content=\"10\">\n  <style>\n    body { background:#0b0c10; color:#c5c6c7; font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, \"Liberation Mono\", monospace; }\n    .wrap { max-width: 950px; margin: 40px auto; padding: 24px; }\n    h1 { color:#66fcf1; margin:0 0 8px 0; }\n    .sub { color:#45a29e; margin-bottom: 18px; }\n    .banner { border:1px solid #66fcf1; border-radius: 10px; padding: 10px 14px; margin-bottom: 14px; background: rgba(102,252,241,0.06); }\n    .grid { display:grid; grid-template-columns: 1fr 1fr; gap: 14px; }\n    .card { border:1px solid #45a29e; border-radius: 10px; padding: 14px 16px; background: rgba(255,255,255,0.03); }\n    .k { color:#66fcf1; }\n    .v { color:#ffffff; }\n    .footer { margin-top: 18px; color:#45a29e; font-size: 12px; }\n    a { color:#66fcf1; text-decoration:none; }\n    a:hover { text-decoration:underline; }\n  </style>\n</head>\n<body>\n  <div class=\"wrap\">\n    <h1>⚡ SEIR-I Ops Panel — Node Online ⚡</h1>\n    <div class=\"sub\">This is your proof-of-life: VM + startup automation + HTTP service.</div>\n\n    <div class=\"banner\">\n      <span class=\"k\">Deploy Banner:</span>\n      <span class=\"v\">$${STUDENT_NAME}</span>\n      <span class=\"k\"> | Startup UTC:</span>\n      <span class=\"v\">$${START_TIME_UTC}</span>\n      <span class=\"k\"> | Auto-refresh:</span>\n      <span class=\"v\">10s</span>\n    </div>\n\n    <div class=\"grid\">\n      <div class=\"card\">\n        <div class=\"k\">Identity</div>\n        <div><span class=\"k\">Project:</span> <span class=\"v\">$${PROJECT_ID}</span></div>\n        <div><span class=\"k\">Instance:</span> <span class=\"v\">$${INSTANCE_NAME}</span></div>\n        <div><span class=\"k\">Hostname:</span> <span class=\"v\">$${HOSTNAME}</span></div>\n        <div><span class=\"k\">Machine:</span> <span class=\"v\">$${MACHINE_TYPE}</span></div>\n      </div>\n\n      <div class=\"card\">\n        <div class=\"k\">Location</div>\n        <div><span class=\"k\">Region:</span> <span class=\"v\">$${REGION}</span></div>\n        <div><span class=\"k\">Zone:</span> <span class=\"v\">$${ZONE}</span></div>\n        <div><span class=\"k\">Uptime:</span> <span class=\"v\">$${UPTIME}</span></div>\n        <div><span class=\"k\">Load Avg:</span> <span class=\"v\">$${LOADAVG}</span></div>\n      </div>\n\n      <div class=\"card\">\n        <div class=\"k\">Network</div>\n        <div><span class=\"k\">VPC:</span> <span class=\"v\">$${VPC}</span></div>\n        <div><span class=\"k\">Subnet:</span> <span class=\"v\">$${SUBNET}</span></div>\n        <div><span class=\"k\">Internal IP:</span> <span class=\"v\">$${INTERNAL_IP}</span></div>\n        <div><span class=\"k\">External IP:</span> <span class=\"v\">$${EXTERNAL_IP}</span></div>\n      </div>\n\n      <div class=\"card\">\n        <div class=\"k\">System</div>\n        <div><span class=\"k\">RAM:</span> <span class=\"v\">$${MEM_USED_MB} used / $${MEM_FREE_MB} free / $${MEM_TOTAL_MB} total (MB)</span></div>\n        <div><span class=\"k\">Disk (/):</span> <span class=\"v\">$${DISK_USED} used / $${DISK_AVAIL} avail / $${DISK_SIZE} total ($${DISK_USEP})</span></div>\n        <div class=\"k\" style=\"margin-top:10px;\">Endpoints</div>\n        <div><a href=\"/healthz\">/healthz</a> (plain text)</div>\n        <div><a href=\"/metadata\">/metadata</a> (JSON)</div>\n      </div>\n    </div>\n\n    <div class=\"footer\">\n      #Chewbacca: Humans celebrate the dashboard. Machines trust /healthz. Engineers curl /metadata.\n    </div>\n  </div>\n</body>\n</html>\nEOF\n\nsystemctl enable nginx >/dev/null 2>&1 || true\nsystemctl restart nginx\n\n#Chewbacca: Proof in terminal too.\necho \"OK: SEIR-I node deployed.\"\necho \"Try:\"\necho \"  curl -s localhost/healthz\"\necho \"  curl -s localhost/metadata | jq .\""
    student_name    = "Michael Anunda"
  }

  name = "week-3-node"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/class75-michaelanunda/regions/us-central1/subnetworks/default"
  }

  reservation_affinity {
    type = "ANY_RESERVATION"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "270593359442-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server"]
  zone = "us-central1-f"

  depends_on = [module.ops_agent_policy]
}

module "ops_agent_policy" {
  source        = "github.com/terraform-google-modules/terraform-google-cloud-operations/modules/ops-agent-policy"
  project       = "class75-michaelanunda"
  zone          = "us-central1-f"
  assignment_id = "goog-ops-agent-v2-template-1-7-0-us-central1-f"
  agents_rule = {
    package_state = "installed"
    version       = "latest"
  }
  instance_filter = {
    all = false
    inclusion_labels = [{
      labels = {
        goog-ops-agent-policy = "v2-template-1-7-0"
      }
    }]
  }
}

```

### 10. Execute terraform init

Open a new terminal session in vsCode and ensure you are in the terraform directory via the command ➡️ pwd

Execute the following command in order to initialize your terraform directory ➡️ terraform init

### 10a. Comment Out depends_on = [module.ops_agent_policy] AND module "ops_agent_policy" within 1-vm.t

Within 1-vm.tf in vsCode, you will need to comment out depends_on = [module.ops_agent_policy] AND module "ops_agent_policy"

This is because terraform initialized the module (terraform init) within the .terraform folder so declaring it again within 1-vm.tf will cause errors when it comes to executing terraform apply

```

# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "week-3-node" {
  boot_disk {
    auto_delete = true
    device_name = "week-3-node"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20260417"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src           = "vm_add-tf"
    goog-ops-agent-policy = "v2-template-1-7-0"
  }

  machine_type = "e2-medium"

  metadata = {
    enable-osconfig = "TRUE"
    startup-script  = "#!/bin/bash\nset -euo pipefail\n\n#Chewbacca: The node awakens. And it will speak in HTML, plain text, and JSON.\n\n#Thanks for Aaron!\nsleep 5\napt update -y\napt install -y nginx curl jq\n\nMETADATA=\"http://metadata.google.internal/computeMetadata/v1\"\nHDR=\"Metadata-Flavor: Google\"\nmd() { curl -fsS -H \"$HDR\" \"$${METADATA}/$1\" || echo \"unknown\"; }\n\nINSTANCE_NAME=\"$(md instance/name)\"\nHOSTNAME=\"$(hostname)\"\nPROJECT_ID=\"$(md project/project-id)\"\nZONE_FULL=\"$(md instance/zone)\"                  # projects/<id>/zones/us-central1-a\nZONE=\"$${ZONE_FULL##*/}\"\nREGION=\"$${ZONE%-*}\"\nMACHINE_TYPE_FULL=\"$(md instance/machine-type)\"\nMACHINE_TYPE=\"$${MACHINE_TYPE_FULL##*/}\"\n\nINTERNAL_IP=\"$(md instance/network-interfaces/0/ip)\"\nEXTERNAL_IP=\"$(md instance/network-interfaces/0/access-configs/0/external-ip)\"\nVPC_FULL=\"$(md instance/network-interfaces/0/network)\"\nSUBNET_FULL=\"$(md instance/network-interfaces/0/subnetwork)\"\nVPC=\"$${VPC_FULL##*/}\"\nSUBNET=\"$${SUBNET_FULL##*/}\"\n\nSTART_TIME_UTC=\"$(date -u +\"%Y-%m-%dT%H:%M:%SZ\")\"\n\n# --- Student banner ---\n# Students set this when creating the VM by adding a metadata key:\n#   student_name = Darth Malgus Jr\nSTUDENT_NAME=\"$(md instance/attributes/student_name)\"\n[[ -z \"$STUDENT_NAME\" || \"$STUDENT_NAME\" == \"unknown\" ]] && STUDENT_NAME=\"Anonymous Padawan (temporarily)\"\n\n# --- Basic system stats ---\nUPTIME=\"$(uptime -p || true)\"\nLOADAVG=\"$(awk '{print $1\" \"$2\" \"$3}' /proc/loadavg 2>/dev/null || echo \"unknown\")\"\n\nMEM_TOTAL_MB=\"$(free -m | awk '/Mem:/ {print $2}')\"\nMEM_USED_MB=\"$(free -m | awk '/Mem:/ {print $3}')\"\nMEM_FREE_MB=\"$(free -m | awk '/Mem:/ {print $4}')\"\n\nDISK_LINE=\"$(df -h / | tail -n 1)\"\nDISK_SIZE=\"$(echo \"$DISK_LINE\" | awk '{print $2}')\"\nDISK_USED=\"$(echo \"$DISK_LINE\" | awk '{print $3}')\"\nDISK_AVAIL=\"$(echo \"$DISK_LINE\" | awk '{print $4}')\"\nDISK_USEP=\"$(echo \"$DISK_LINE\" | awk '{print $5}')\"\n\n# --- Nginx config: add endpoints /healthz and /metadata ---\ncat > /etc/nginx/sites-available/default <<'EOF'\nserver {\n    listen 80 default_server;\n    listen [::]:80 default_server;\n\n    root /var/www/html;\n    index index.html;\n\n    #Chewbacca: The homepage is for humans.\n    location = / {\n        try_files /index.html =404;\n    }\n\n    #Chewbacca: Health checks are for machines. Keep it boring.\n    location = /healthz {\n        default_type text/plain;\n        return 200 \"ok\\n\";\n    }\n\n    #Chewbacca: Metadata is for engineers and scripts.\n    location = /metadata {\n        default_type application/json;\n        try_files /metadata.json =404;\n    }\n}\nEOF\n\n# --- Write JSON endpoint file ---\ncat > /var/www/html/metadata.json <<EOF\n{\n  \"service\": \"seir-i-node\",\n  \"student_name\": \"$(echo \"$STUDENT_NAME\" | sed 's/\"/\\\\\"/g')\",\n  \"project_id\": \"$PROJECT_ID\",\n  \"instance_name\": \"$INSTANCE_NAME\",\n  \"hostname\": \"$HOSTNAME\",\n  \"region\": \"$REGION\",\n  \"zone\": \"$ZONE\",\n  \"machine_type\": \"$MACHINE_TYPE\",\n  \"network\": {\n    \"vpc\": \"$VPC\",\n    \"subnet\": \"$SUBNET\",\n    \"internal_ip\": \"$INTERNAL_IP\",\n    \"external_ip\": \"$EXTERNAL_IP\"\n  },\n  \"health\": {\n    \"uptime\": \"$UPTIME\",\n    \"load_avg\": \"$LOADAVG\",\n    \"ram_mb\": {\"used\": $MEM_USED_MB, \"free\": $MEM_FREE_MB, \"total\": $MEM_TOTAL_MB},\n    \"disk_root\": {\"size\": \"$DISK_SIZE\", \"used\": \"$DISK_USED\", \"avail\": \"$DISK_AVAIL\", \"use_pct\": \"$DISK_USEP\"}\n  },\n  \"startup_utc\": \"$START_TIME_UTC\"\n}\nEOF\n\n# --- Write the main HTML dashboard ---\ncat > /var/www/html/index.html <<EOF\n<!DOCTYPE html>\n<html>\n<head>\n  <meta charset=\"utf-8\"/>\n  <title>SEIR-I Ops Panel</title>\n  <meta http-equiv=\"refresh\" content=\"10\">\n  <style>\n    body { background:#0b0c10; color:#c5c6c7; font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, \"Liberation Mono\", monospace; }\n    .wrap { max-width: 950px; margin: 40px auto; padding: 24px; }\n    h1 { color:#66fcf1; margin:0 0 8px 0; }\n    .sub { color:#45a29e; margin-bottom: 18px; }\n    .banner { border:1px solid #66fcf1; border-radius: 10px; padding: 10px 14px; margin-bottom: 14px; background: rgba(102,252,241,0.06); }\n    .grid { display:grid; grid-template-columns: 1fr 1fr; gap: 14px; }\n    .card { border:1px solid #45a29e; border-radius: 10px; padding: 14px 16px; background: rgba(255,255,255,0.03); }\n    .k { color:#66fcf1; }\n    .v { color:#ffffff; }\n    .footer { margin-top: 18px; color:#45a29e; font-size: 12px; }\n    a { color:#66fcf1; text-decoration:none; }\n    a:hover { text-decoration:underline; }\n  </style>\n</head>\n<body>\n  <div class=\"wrap\">\n    <h1>⚡ SEIR-I Ops Panel — Node Online ⚡</h1>\n    <div class=\"sub\">This is your proof-of-life: VM + startup automation + HTTP service.</div>\n\n    <div class=\"banner\">\n      <span class=\"k\">Deploy Banner:</span>\n      <span class=\"v\">$${STUDENT_NAME}</span>\n      <span class=\"k\"> | Startup UTC:</span>\n      <span class=\"v\">$${START_TIME_UTC}</span>\n      <span class=\"k\"> | Auto-refresh:</span>\n      <span class=\"v\">10s</span>\n    </div>\n\n    <div class=\"grid\">\n      <div class=\"card\">\n        <div class=\"k\">Identity</div>\n        <div><span class=\"k\">Project:</span> <span class=\"v\">$${PROJECT_ID}</span></div>\n        <div><span class=\"k\">Instance:</span> <span class=\"v\">$${INSTANCE_NAME}</span></div>\n        <div><span class=\"k\">Hostname:</span> <span class=\"v\">$${HOSTNAME}</span></div>\n        <div><span class=\"k\">Machine:</span> <span class=\"v\">$${MACHINE_TYPE}</span></div>\n      </div>\n\n      <div class=\"card\">\n        <div class=\"k\">Location</div>\n        <div><span class=\"k\">Region:</span> <span class=\"v\">$${REGION}</span></div>\n        <div><span class=\"k\">Zone:</span> <span class=\"v\">$${ZONE}</span></div>\n        <div><span class=\"k\">Uptime:</span> <span class=\"v\">$${UPTIME}</span></div>\n        <div><span class=\"k\">Load Avg:</span> <span class=\"v\">$${LOADAVG}</span></div>\n      </div>\n\n      <div class=\"card\">\n        <div class=\"k\">Network</div>\n        <div><span class=\"k\">VPC:</span> <span class=\"v\">$${VPC}</span></div>\n        <div><span class=\"k\">Subnet:</span> <span class=\"v\">$${SUBNET}</span></div>\n        <div><span class=\"k\">Internal IP:</span> <span class=\"v\">$${INTERNAL_IP}</span></div>\n        <div><span class=\"k\">External IP:</span> <span class=\"v\">$${EXTERNAL_IP}</span></div>\n      </div>\n\n      <div class=\"card\">\n        <div class=\"k\">System</div>\n        <div><span class=\"k\">RAM:</span> <span class=\"v\">$${MEM_USED_MB} used / $${MEM_FREE_MB} free / $${MEM_TOTAL_MB} total (MB)</span></div>\n        <div><span class=\"k\">Disk (/):</span> <span class=\"v\">$${DISK_USED} used / $${DISK_AVAIL} avail / $${DISK_SIZE} total ($${DISK_USEP})</span></div>\n        <div class=\"k\" style=\"margin-top:10px;\">Endpoints</div>\n        <div><a href=\"/healthz\">/healthz</a> (plain text)</div>\n        <div><a href=\"/metadata\">/metadata</a> (JSON)</div>\n      </div>\n    </div>\n\n    <div class=\"footer\">\n      #Chewbacca: Humans celebrate the dashboard. Machines trust /healthz. Engineers curl /metadata.\n    </div>\n  </div>\n</body>\n</html>\nEOF\n\nsystemctl enable nginx >/dev/null 2>&1 || true\nsystemctl restart nginx\n\n#Chewbacca: Proof in terminal too.\necho \"OK: SEIR-I node deployed.\"\necho \"Try:\"\necho \"  curl -s localhost/healthz\"\necho \"  curl -s localhost/metadata | jq .\""
    student_name    = "Michael Anunda"
  }

  name = "week-3-node"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/class75-michaelanunda/regions/us-central1/subnetworks/default"
  }

  reservation_affinity {
    type = "ANY_RESERVATION"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "270593359442-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server"]
  zone = "us-central1-f"

#   depends_on = [module.ops_agent_policy]
}

# module "ops_agent_policy" {
#   source        = "github.com/terraform-google-modules/terraform-google-cloud-operations/modules/ops-agent-policy"
#   project       = "class75-michaelanunda"
#   zone          = "us-central1-f"
#   assignment_id = "goog-ops-agent-v2-template-1-7-0-us-central1-f"
#   agents_rule = {
#     package_state = "installed"
#     version       = "latest"
#   }
#   instance_filter = {
#     all = false
#     inclusion_labels = [{
#       labels = {
#         goog-ops-agent-policy = "v2-template-1-7-0"
#       }
#     }]
#   }
# }

```

### 11. Execute terraform plan

Go back to the terminal session in vsCode for the terraform directory

Execute the following command in order to view the execution plan for the terraform files in the terraform directory ➡️ terraform plan

Side note: You can also put the output of terraform plan within a text file via the following command ➡️ terraform plan > plan.txt

### 12. Execute terraform apply

Go back to the terminal session in vsCode for the terraform directory

Execute the following command in order to create the infrastructure proposed in terraform plan ➡️ terraform apply

Type yes when prompted within the terminal session

Side note: You can also put the output of terraform apply within a text file via the following command ➡️ terraform apply -auto-approve > tf-apply-proof.txt

### 13. Confirm that the vm is created via GCP

Click Create and wait until the Status of the VM is showing a green check mark

Go to the VM instances menu in GCP and wait until the Status of the VM is showing a green check mark

## Verification Steps

After the VM boots, locate the External IP of the VM and copy it.

### 1. Browser Verification

Open the following URL within a new browser tab:

http://<EXTERNAL_IP>/

IMPORTANT - replace paste the copied External IP of the VM into <EXTERNAL_IP> ➡️ http://34.123.220.96/

You should see the SEIR‑I Ops Panel.

### 2. Health Endpoint

Open the following URL within a new browser tab:

http://<EXTERNAL_IP>/healthz

IMPORTANT - replace paste the copied External IP of the VM into <EXTERNAL_IP> ➡️ http://34.123.220.96/healthz

Expected output:

ok

### 3. Metadata Endpoint

Open the following URL within a new browser tab:

http://<EXTERNAL_IP>/metadata

IMPORTANT - replace paste the copied External IP of the VM into <EXTERNAL_IP> ➡️ http://34.123.220.96/metadata

Expected: valid JSON containing instance_name and region.

## SSH Verification (Required Screenshots)

Within the VM instances menu in GCP, click SSH for the running VM (under Connect), then click Authorize when the prompt box appears

Once inside thr SSH session for the VM, run the following commands:

```
curl -s localhost/healthz ➡️ This command will provide Machine Proof for supera.sh
curl -s localhost/metadata | jq . ➡️ This command will provide Engineer Proof for supera.sh
systemctl status nginx --no-pager ➡️ This command will provide Service Proof for supera.sh

```

## Grading Script Instructions

The grading script validates:

- Homepage reachability
- /healthz correctness
- /metadata JSON validity
- Required metadata fields

### 1. Download the grading script

The grading script, gate_gcp_vm_http_ok.sh, can be downloaded from here ➡️ https://github.com/BalericaAI/SEIR-1/blob/main/weekly_lessons/weeka/script/gate_gcp_vm_http_ok.sh

### 2. Run the script

Within the terminal on your local machine, cd into the directory where gate_gcp_vm_http_ok.sh lives and execute the following command:

VM_IP=<EXTERNAL_IP> ./gate_gcp_vm_http_ok.sh

IMPORTANT:

Replace <EXTERNAL_IP> with your VM’s IP:

FOR EXAMPLE ➡️ VM_IP=34.82.55.21 ./gate_gcp_vm_http_ok.sh

### 3. Expected PASS Output from the script

Lab 1 Gate Result: PASS

PASS: Homepage reachable (HTTP 200)
PASS: /healthz endpoint returned 'ok'
PASS: /metadata returned valid JSON
PASS: metadata contains instance_name
PASS: metadata contains region

### 4. Files Generated

Once gate_gcp_vm_http_ok.sh is executed successfully the following files will be generated in the same directory:

- badge.txt
- gate_result.json

You can move these file to other directories once generated (e.g., deliverables/)

## Repository Layout
```
03-week-03/
├── .gitignore
├── README.md
├── deliverables/
│   ├── .gitignore
│   ├── badge.txt
│   ├── gate_result.json
│   ├── plan.txt
│   ├── tf-apply-proof.txt
│   ├── udemy - masterclass - section 10.png
│   ├── udemy - security - section 13.png
│   ├── vm-url-proof.png
│   └── terraform/
│       ├── .gitignore
│       ├── 0-authentication.tf
│       └── 1-vm.tf
└── scripts/
    ├── .gitignore
    ├── gate_gcp_vm_http_ok.sh
    └── supera.sh
```

## Engineering Philosophy from this Lab

Treat infrastructure like code in Terraform to achieve repeatable, reviewable, version-controlled, and reproducible deployments

Click-ops through the GCP console may be faster for a first-time test, but it is more prone to human error, drift, and undocumented changes

In essence, build systems that can be reasoned about, tested, and repeated

---In Addition---

Cloud engineers do not say “it works on my machine.”

They prove the following:

- The service is reachable
- The health endpoint responds correctly
- Metadata is accurate and machine-readable
- The deployment is automated and reproducible

This lab reinforces those principles.