variable "cluster_name" {
  description = "Name prefix for all cluster resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "Optional override for instance type"
  type        = string
  default     = null
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
}

variable "server_port" {
  description = "Port the web server listens on"
  type        = number
  default     = 8080
}

variable "server_text" {
  description = "Text displayed on the web page"
  type        = string
  default     = "Hello from Terraform module"
}

variable "enable_autoscaling" {
  description = "Enable autoscaling policies"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags applied to supported resources"
  type        = map(string)
  default     = {}
}

variable "security_group_names" {
  description = "Security groups to create"
  type        = set(string)
  default     = ["instance", "alb"]
}