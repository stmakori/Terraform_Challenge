variable "db_password" {
  description = "Master password for the RDS instance. Pass via TF_VAR_db_password or Secrets Manager; never commit it."
  type        = string
  sensitive   = true
}
