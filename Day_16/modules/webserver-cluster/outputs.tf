output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "asg_name" {
  description = "ASG name"
  value       = aws_autoscaling_group.this.name
}

output "alerts_topic_arn" {
  description = "SNS topic for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "log_bucket_name" {
  description = "S3 bucket for logs"
  value       = aws_s3_bucket.logs.bucket
}