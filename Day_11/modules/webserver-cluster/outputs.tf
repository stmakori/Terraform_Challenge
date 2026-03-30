output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "instance_type" {
  description = "Resolved instance type"
  value       = local.instance_type
}

output "cluster_sizes" {
  description = "Resolved min and max cluster sizes"
  value = {
    min_size = local.min_size
    max_size = local.max_size
  }
}

output "alarm_arn" {
  description = "CloudWatch alarm ARN if monitoring is enabled"
  value       = local.enable_monitoring ? aws_cloudwatch_metric_alarm.high_cpu[0].arn : null
}

output "route53_record_fqdn" {
  description = "Route53 record FQDN if created"
  value       = var.create_dns_record ? aws_route53_record.alb[0].fqdn : null
}

output "vpc_id" {
  description = "VPC ID in use"
  value       = local.vpc_id
}

output "subnet_ids" {
  description = "Subnet IDs in use"
  value       = local.subnet_ids
}