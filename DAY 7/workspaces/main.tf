provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "web_sg" {
  name        = "workspace-${terraform.workspace}-sg"
  description = "Security group for workspace ${terraform.workspace}"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP app"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "workspace-${terraform.workspace}-sg"
    Environment = terraform.workspace
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type[terraform.workspace]
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y python3
              cat > index.html <<HTML
              <html>
                <body style="font-family: Arial; text-align:center; margin-top:40px;">
                  <h1>Terraform Workspace Demo</h1>
                  <p>Environment: ${terraform.workspace}</p>
                  <p>Instance Type: ${var.instance_type[terraform.workspace]}</p>
                </body>
              </html>
              HTML
              nohup python3 -m http.server 8080 --bind 0.0.0.0 >/var/log/webapp.log 2>&1 &
              EOF

  tags = {
    Name        = "${var.instance_name_prefix}-${terraform.workspace}"
    Environment = terraform.workspace
  }
}