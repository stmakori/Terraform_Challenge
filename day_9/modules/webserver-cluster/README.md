# webserver-cluster
# Webserver Cluster Module

This module deploys a webserver cluster on AWS using an Application Load Balancer, Launch Template, and Auto Scaling Group.

## Inputs

- `cluster_name` (string): Name prefix for all resources
- `instance_type` (string): EC2 instance type. Default: `t2.micro`
- `min_size` (number): Minimum ASG size
- `max_size` (number): Maximum ASG size
- `server_port` (number): Web server port. Default: `8080`
- `server_text` (string): Text shown on the web page. Default: `Hello from Terraform module`

## Outputs

- `alb_dns_name`: DNS name of the ALB
- `asg_name`: Name of the Auto Scaling Group
- `alb_security_group_id`: Security group ID for the ALB

## Example Usage

```hcl
module "webserver_cluster" {
  source        = "github.com/your-username/terraform-aws-webserver-cluster?ref=v0.0.1"
  cluster_name  = "webservers-dev"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 4
}