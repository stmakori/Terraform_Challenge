variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "secret_name" {
  description = "Name of the AWS Secrets Manager secret"
  type        = string
  default     = "day13/db-creds"
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "day13-secrets-demo"
}