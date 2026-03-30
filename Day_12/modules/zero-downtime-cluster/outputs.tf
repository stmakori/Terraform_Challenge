output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "active_environment" {
  description = "Currently active environment"
  value       = var.active_environment
}