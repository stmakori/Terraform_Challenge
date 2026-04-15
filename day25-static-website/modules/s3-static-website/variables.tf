variable "bucket_name" {
  type = string
}

variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Invalid environment"
  }
}

variable "index_document" {
  type    = string
  default = "index.html"
}

variable "error_document" {
  type    = string
  default = "error.html"
}

variable "tags" {
  type    = map(string)
  default = {}
}
