provider "aws" {
  region = "us-east-1"
}

locals {
  is_production = var.environment == "production"

  instance_type     = local.is_production ? "t2.medium" : "t2.micro"
  min_size          = local.is_production ? 3 : 1
  max_size          = local.is_production ? 10 : 3
  enable_monitoring = local.is_production ? var.enable_detailed_monitoring : false
  deletion_policy   = local.is_production ? "Retain" : "Delete"

  merged_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Project     = var.cluster_name
    }
  )
}

data "aws_vpc" "existing" {
  count = var.use_existing_vpc ? 1 : 0

  default = true
}

resource "aws_vpc" "new" {
  count      = var.use_existing_vpc ? 0 : 1
  cidr_block = "10.0.0.0/16"

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-vpc"
  })
}

locals {
  vpc_id = var.use_existing_vpc ? data.aws_vpc.existing[0].id : aws_vpc.new[0].id
}

data "aws_subnets" "existing" {
  count = var.use_existing_vpc ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}

resource "aws_subnet" "new" {
  count             = var.use_existing_vpc ? 0 : 2
  vpc_id            = local.vpc_id
  cidr_block        = count.index == 0 ? "10.0.1.0/24" : "10.0.2.0/24"
  availability_zone = count.index == 0 ? "us-east-1a" : "us-east-1b"

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-subnet-${count.index + 1}"
  })
}

locals {
  subnet_ids = var.use_existing_vpc ? data.aws_subnets.existing[0].ids : aws_subnet.new[*].id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "instance" {
  name        = "${var.cluster_name}-instance-sg"
  description = "Security group for EC2 instances"
  vpc_id      = local.vpc_id

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-instance-sg"
  })
}

resource "aws_security_group_rule" "instance_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.instance.id
  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "instance_egress" {
  type              = "egress"
  security_group_id = aws_security_group.instance.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "alb" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = local.vpc_id

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-alb-sg"
  })
}

resource "aws_security_group_rule" "alb_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.cluster_name}-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = local.instance_type

  vpc_security_group_ids = [aws_security_group.instance.id]

  monitoring {
    enabled = local.enable_monitoring
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    server_text = var.server_text
    environment = var.environment
  }))

  tags = local.merged_tags
}

resource "aws_lb" "this" {
  name               = substr("${var.cluster_name}-alb", 0, 32)
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = local.subnet_ids

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-alb"
  })
}

resource "aws_lb_target_group" "this" {
  name     = substr("${var.cluster_name}-tg", 0, 32)
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id

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
  desired_capacity    = local.min_size
  min_size            = local.min_size
  max_size            = local.max_size
  vpc_zone_identifier = local.subnet_ids
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

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = local.enable_monitoring ? 1 : 0

  alarm_name          = "${var.cluster_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU utilization exceeded 80%"

  tags = local.merged_tags
}

data "aws_route53_zone" "primary" {
  count        = var.create_dns_record ? 1 : 0
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "alb" {
  count   = var.create_dns_record ? 1 : 0
  zone_id = data.aws_route53_zone.primary[0].zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}