variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "day14-multiregion"
}

variable "enable_versioning" {
  description = "Enable versioning on both buckets"
  type        = bool
  default     = true
}