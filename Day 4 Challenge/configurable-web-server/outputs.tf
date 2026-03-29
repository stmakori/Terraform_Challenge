output "instance_public_ip" {
  description = "Public IP address of the configurable web server"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the configurable web server"
  value       = aws_instance.web.public_dns
}

output "application_url" {
  description = "Application URL"
  value       = "http://${aws_instance.web.public_dns}:${var.server_port}"
}