#!/bin/bash

cat <<EOF > index.html
<h1>Day 22 Integrated Workflow</h1>
<p>Terraform Deployment Successful</p>
EOF

python3 -m http.server 80 &