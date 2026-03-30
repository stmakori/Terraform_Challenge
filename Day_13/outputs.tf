output "db_instance_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.example.endpoint
}

output "db_connection_string" {
  description = "Database connection string"
  value       = "mysql://${aws_db_instance.example.username}@${aws_db_instance.example.endpoint}/${aws_db_instance.example.db_name}"
  sensitive   = true
}

output "secret_arn" {
  description = "Secrets Manager secret ARN"
  value       = data.aws_secretsmanager_secret.db.arn
}

output "db_password_echo" {
  description = "Example sensitive output"
  value       = var.db_password
  sensitive   = true
}