output "environment" {
  value = var.environment
}

output "instance_id" {
  value = aws_instance.web.id
}

output "subnet_id" {
  value = aws_default_subnet.default_az1.id
}