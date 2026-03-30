variable "cluster_name" {
  description = "Name prefix for all cluster resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment: dev, staging, or production"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "server_port" {
  description = "Port the web server listens on"
  type        = number
  default     = 8080
}

variable "server_text" {
  description = "Text displayed on the web page"
  type        = string
  default     = "Hello from Terraform"
}

variable "enable_detailed_monitoring" {
  description = "Enable CloudWatch detailed monitoring"
  type        = bool
  default     = false
}

variable "create_dns_record" {
  description = "Whether to create a Route53 DNS record for the ALB"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "DNS name to create if Route53 record is enabled"
  type        = string
  default     = "example.com"
}

variable "hosted_zone_name" {
  description = "Route53 hosted zone name"
  type        = string
  default     = "example.com"
}

variable "use_existing_vpc" {
  description = "Use an existing VPC instead of creating a new one"
  type        = bool
  default     = true
}

variable "existing_vpc_name" {
  description = "Name tag of the existing VPC to use"
  type        = string
  default     = "default"
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}