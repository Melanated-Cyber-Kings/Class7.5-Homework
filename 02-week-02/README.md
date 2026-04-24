# References

- https://github.com/BalericaAI/SEIR-1/tree/main/weekly_lessons/weeka

# ☁️ SEIR‑I — Week 2 (GCP VM Deployment & Grading)

Hands‑on cloud engineering practice using Google Cloud Platform (GCP).
This repository contains the deliverables, verification artifacts, and grading outputs for SEIR‑I Week 2, focused on deploying a Compute Engine VM with an automated startup script and validating service correctness.

## Repository Purpose

This project is intended to:

- Deploy a GCP VM using a provided startup script
- Serve a custom homepage, health endpoint, and metadata endpoint
- Validate the deployment using an automated grading script

## Lab Overview — Week 2

The Week 2 lab introduces foundational cloud engineering concepts:

- Creating a Compute Engine VM in GCP
- Using a startup script to automate configuration of that VM
- Serving HTTP endpoints (`/`, `/healthz`, `/metadata`)
- Verifying service health and metadata correctness
- Running an automated grading script
- Producing confirmation artifacts from the grading script (e.g., `badge.txt` and `gate_result.json`)

This mirrors real‑world cloud engineering workflows: automation, validation, and reproducibility.

## Prerequisites

- Google Cloud Platform account
- Billing enabled (free tier is sufficient)
- Compute Engine API enabled
- Google Cloud Shell or local terminal with curl (curl --version) and jq (jq --version)
- Provided startup script (supera.sh)
- Provided grading script (gate_gcp_vm_http_ok.sh)

## VM Deployment Instructions

Follow these steps (1. Create the VM, 2. Add the Startup Script, 3. Add Metadata, and 4. Create the VM) to deploy the Compute Engine VM in GCP.

### 1. Create the VM

Login to your GCP account and select your desired project

Click on the Navigation Menu to the left then navigate to Compute Engine → VM Instances

Within the VM instances menu click "Create Instance"

Enter/Select the following under Machine configuration:

Name: week-2-node
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

### 4. Create the VM

Click Create and wait until the Status of the VM is showing a green check mark

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
02-week-02/
├── deliverables/
│   ├── badge.txt
│   ├── Browser Proof.png
│   ├── Engineer Proof.png
│   ├── gate_result.json
│   ├── Machine Proof.png
│   └── Service Proof.png
├── scripts/
│   ├── gate_gcp_vm_http_ok.sh
│   └── supera.sh
└── README.md
```

## Engineering Philosophy from this Lab

Cloud engineers do not say “it works on my machine.”

They prove the following:

- The service is reachable
- The health endpoint responds correctly
- Metadata is accurate and machine-readable
- The deployment is automated and reproducible

This lab reinforces those principles.