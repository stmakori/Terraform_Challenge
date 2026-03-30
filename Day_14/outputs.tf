output "primary_bucket_name" {
  description = "Primary S3 bucket in the default region"
  value       = aws_s3_bucket.primary.bucket
}

output "replica_bucket_name" {
  description = "Replica S3 bucket in the aliased region"
  value       = aws_s3_bucket.replica.bucket
}

output "primary_region" {
  description = "Primary region"
  value       = var.primary_region
}

output "secondary_region" {
  description = "Secondary region"
  value       = var.secondary_region
}

output "replication_role_arn" {
  description = "IAM role ARN used for replication"
  value       = aws_iam_role.replication.arn
}