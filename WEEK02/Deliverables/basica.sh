#!/bin/bash

apt update -y
apt install -y nginx

cat <<EOF > /var/www/html/index.html
<html>
<head>
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

systemctl restart nginx