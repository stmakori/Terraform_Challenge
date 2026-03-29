# Webserver Cluster Module

This Terraform module creates:
- A security group for EC2 instances
- A security group for the Application Load Balancer
- A launch template
- An Auto Scaling Group
- An Application Load Balancer
- A target group
- A listener

## Inputs

- `cluster_name` - Name used for cluster resources
- `instance_type` - EC2 instance type
- `min_size` - Minimum number of instances
- `max_size` - Maximum number of instances
- `server_port` - Port the web server runs on

## Outputs

- `alb_dns_name` - DNS name of the load balancer
- `asg_name` - Name of the Auto Scaling Group