variable "cluster_name" {
  description = "Name prefix for the cluster"
  type        = string
}

variable "server_port" {
  description = "Port the app runs on"
  type        = number
  default     = 8080
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "Minimum ASG size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum ASG size"
  type        = number
  default     = 2
}

variable "app_version" {
  description = "Application version shown by the server"
  type        = string
  default     = "v1"
}

variable "active_environment" {
  description = "Which environment is currently active: blue or green"
  type        = string
  default     = "blue"

  validation {
    condition     = contains(["blue", "green"], var.active_environment)
    error_message = "active_environment must be either blue or green."
  }
}