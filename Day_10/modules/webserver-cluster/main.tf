provider "aws" {
  region = "us-east-1"
}

locals {
  resolved_instance_type = var.instance_type != null ? var.instance_type : (
    var.environment == "production" ? "t2.medium" : "t2.micro"
  )

  security_group_descriptions = {
    instance = "Security group for EC2 instances"
    alb      = "Security group for ALB"
  }

  merged_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Project     = var.cluster_name
    }
  )
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "this" {
  for_each = var.security_group_names

  name        = "${var.cluster_name}-${each.key}-sg"
  description = local.security_group_descriptions[each.key]
  vpc_id      = data.aws_vpc.default.id

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-${each.key}-sg"
  })
}

resource "aws_security_group_rule" "instance_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.this["instance"].id
  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this["alb"].id
}

resource "aws_security_group_rule" "instance_egress" {
  type              = "egress"
  security_group_id = aws_security_group.this["instance"].id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.this["alb"].id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  security_group_id = aws_security_group.this["alb"].id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.cluster_name}-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = local.resolved_instance_type

  vpc_security_group_ids = [aws_security_group.this["instance"].id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    server_text = var.server_text
  }))

  tags = local.merged_tags
}

resource "aws_lb" "this" {
  name               = substr("${var.cluster_name}-alb", 0, 32)
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this["alb"].id]
  subnets            = data.aws_subnets.default.ids

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-alb"
  })
}

resource "aws_lb_target_group" "this" {
  name     = substr("${var.cluster_name}-tg", 0, 32)
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-tg"
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_autoscaling_group" "this" {
  name                = "${var.cluster_name}-asg"
  desired_capacity    = var.min_size
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.this.arn]
  health_check_type   = "ELB"
  depends_on          = [aws_lb_listener.http]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  count = var.enable_autoscaling ? 1 : 0

  name                   = "${var.cluster_name}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_autoscaling_policy" "scale_in" {
  count = var.enable_autoscaling ? 1 : 0

  name                   = "${var.cluster_name}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}