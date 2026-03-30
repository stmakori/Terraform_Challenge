#!/usr/bin/env bash
#!/bin/bash
dnf update -y
dnf install -y python3

cat > index.html <<EOF
<html>
  <head><title>${server_text}</title></head>
  <body>
    <h1>${server_text}</h1>
    <p>Environment: ${environment}</p>
    <p>Running on port ${server_port}</p>
  </body>
</html>
EOF

nohup python3 -m http.server ${server_port} > /var/log/webserver.log 2>&1 &