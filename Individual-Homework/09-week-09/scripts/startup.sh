#!/bin/bash
set -euxo pipefail

# Update and install Apache (httpd) for CentOS
yum update -y
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# GCP Metadata server base URL and header
METADATA_URL="http://metadata.google.internal/computeMetadata/v1"
METADATA_FLAVOR_HEADER="Metadata-Flavor: Google"

# Fetch instance metadata
local_ipv4=$(curl -H "${METADATA_FLAVOR_HEADER}" -s "${METADATA_URL}/instance/network-interfaces/0/ip")
zone=$(curl -H "${METADATA_FLAVOR_HEADER}" -s "${METADATA_URL}/instance/zone")
project_id=$(curl -H "${METADATA_FLAVOR_HEADER}" -s "${METADATA_URL}/project/project-id")
network_tags=$(curl -H "${METADATA_FLAVOR_HEADER}" -s "${METADATA_URL}/instance/tags")
student_name=$(curl -H "${METADATA_FLAVOR_HEADER}" -s "${METADATA_URL}/instance/attributes/student_name")

# Create a simple HTML page with instance metadata
cat <<EOF > /var/www/html/index.html
<html><body>
<h2>REGION A</h2>
<h3>Created with a direct input startup script!</h3>
<p><b>Student Name:</b> $student_name</p>
<p><b>Instance Name:</b> $(hostname -f)</p>
<p><b>Instance Private IP Address:</b> $local_ipv4</p>
<p><b>Zone:</b> $zone</p>
<p><b>Project ID:</b> $project_id</p>
<p><b>Network Tags:</b> $network_tags</p>
</body></html>
EOF