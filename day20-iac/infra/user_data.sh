#!/bin/bash

echo "Starting web server..."

cat <<EOF > index.html
<h1>Terraform App Version: v3</h1>
<p>Deployed using Infrastructure as Code</p>
EOF

python3 -m http.server 80 &
