output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "security_group_ids" {
  description = "Map of security group IDs keyed by name"
  value       = { for name, sg in aws_security_group.this : name => sg.id }
}

output "autoscaling_policy_names" {
  description = "Autoscaling policy names if enabled"
  value = {
    scale_out = var.enable_autoscaling ? aws_autoscaling_policy.scale_out[0].name : null
    scale_in  = var.enable_autoscaling ? aws_autoscaling_policy.scale_in[0].name : null
  }
}