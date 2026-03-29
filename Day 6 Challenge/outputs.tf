output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.web_server.public_ip
}

output "instance_public_dns" {
  description = "EC2 public DNS"
  value       = aws_instance.web_server.public_dns
}

output "application_url" {
  description = "Application URL"
  value       = "http://${aws_instance.web_server.public_dns}:${var.server_port}"
}

output "state_bucket_name" {
  description = "S3 bucket used for Terraform state"
  value       = aws_s3_bucket.tf_state.bucket
}

output "lock_table_name" {
  description = "DynamoDB table used for state locking"
  value       = aws_dynamodb_table.tf_locks.name
}