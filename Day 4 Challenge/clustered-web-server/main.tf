terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "all" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_subnets" {
  for_each          = toset(slice(data.aws_availability_zones.all.names, 0, 2))
  availability_zone = each.value
}

resource "aws_security_group" "alb_sg" {
  name        = var.alb_security_group_name
  description = "Security group for ALB"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr_blocks
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.alb_security_group_name
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_security_group" "instance_sg" {
  name        = var.instance_security_group_name
  description = "Security group for EC2 instances in ASG"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description     = "Application traffic from ALB"
    from_port       = var.server_port
    to_port         = var.server_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.instance_security_group_name
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y python3
              cat > index.html <<HTML
              <html>
                <head><title>${var.project_name}</title></head>
                <body style="font-family: Arial; text-align:center; margin-top:40px;">
                  <h1>${var.web_message}</h1>
                  <p>Served from Auto Scaling Group</p>
                  <p>Environment: ${var.environment}</p>
                  <p>Port: ${var.server_port}</p>
                </body>
              </html>
              HTML
              nohup python3 -m http.server ${var.server_port} --bind 0.0.0.0 >/var/log/webapp.log 2>&1 &
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.project_name}-asg-instance"
      Environment = var.environment
      Project     = var.project_name
    }
  }
}

resource "aws_lb" "app" {
  name               = var.alb_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for s in aws_default_subnet.default_subnets : s.id]

  tags = {
    Name        = var.alb_name
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_lb_target_group" "app" {
  name     = var.target_group_name
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = var.target_group_name
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_autoscaling_group" "app" {
  name                      = var.asg_name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = [for s in aws_default_subnet.default_subnets : s.id]
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.app.arn]
  wait_for_capacity_timeout = "10m"

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }
}