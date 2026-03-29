variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used in resource tags"
  type        = string
  default     = "day4-ha-webapp"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "instance_type" {
  description = "EC2 instance type for ASG instances"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "Minimum number of EC2 instances in the ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the ASG"
  type        = number
  default     = 5
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the ASG"
  type        = number
  default     = 2
}

variable "alb_name" {
  description = "Application Load Balancer name"
  type        = string
  default     = "day4-app-alb"
}

variable "target_group_name" {
  description = "ALB target group name"
  type        = string
  default     = "day4-app-tg"
}

variable "asg_name" {
  description = "Auto Scaling Group name"
  type        = string
  default     = "day4-app-asg"
}

variable "alb_security_group_name" {
  description = "Security group name for ALB"
  type        = string
  default     = "day4-alb-sg"
}

variable "instance_security_group_name" {
  description = "Security group name for ASG instances"
  type        = string
  default     = "day4-instance-sg"
}

variable "allowed_http_cidr_blocks" {
  description = "CIDR blocks allowed to access the ALB over HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH into instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "web_message" {
  description = "Message displayed on the load-balanced application page"
  type        = string
  default     = "Hello from my highly available Terraform web app!"
}