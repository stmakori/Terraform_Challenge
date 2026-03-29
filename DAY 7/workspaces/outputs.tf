output "workspace_name" {
  value       = terraform.workspace
  description = "Current Terraform workspace"
}

output "instance_id" {
  value       = aws_instance.web.id
  description = "EC2 instance ID"
}

output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "EC2 public IP"
}

output "instance_public_dns" {
  value       = aws_instance.web.public_dns
  description = "EC2 public DNS"
}

output "subnet_id" {
  value       = aws_default_subnet.default_az1.id
  description = "Subnet ID for remote state demo"
}