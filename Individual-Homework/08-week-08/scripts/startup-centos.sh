#!/bin/bash

# Install nginx (RHEL/CentOS/Rocky use yum or dnf)
yum install -y epel-release
yum install -y nginx

# Default nginx web root folder for RHEL/CentOS/Rocky
WEBROOT="/usr/share/nginx/html"

cat <<'EOF' > ${WEBROOT}/index.html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>SEIR-I Node</title>

<style>
body {
background-color:black;
color:#00ff00;
font-family:monospace;
padding:40px;
}
</style>
</head>

<body>

<pre>

Initializing Cloud Node...

Connecting to GCP Infrastructure...
Loading System Modules...

███████╗███████╗██╗██████╗
██╔════╝██╔════╝██║██╔══██╗
███████╗█████╗  ██║██████╔╝
╚════██║██╔══╝  ██║██╔══██╗
███████║███████╗██║██║  ██║
╚══════╝╚══════╝╚═╝╚═╝  ╚═╝

System Status: ONLINE

You deployed your first cloud server.

</pre>

</body>
</html>
EOF

systemctl enable nginx
systemctl restart nginx