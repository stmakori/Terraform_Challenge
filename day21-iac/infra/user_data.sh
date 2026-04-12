#!/bin/bash

cat <<EOF > index.html
<h1>Terraform App Version: v4</h1>
<p>Day 21 Infrastructure Deployment Workflow</p>
EOF

python3 -m http.server 80 &
