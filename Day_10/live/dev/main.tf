provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../modules/webserver-cluster"

  cluster_name       = "webservers-dev"
  environment        = "dev"
  min_size           = 2
  max_size           = 4
  server_text        = "Hello from Day 10 DEV"
  enable_autoscaling = true

  common_tags = {
    Owner = "Stephanie"
    Day   = "10"
  }
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}

output "security_group_ids" {
  value = module.webserver_cluster.security_group_ids
}

output "autoscaling_policy_names" {
  value = module.webserver_cluster.autoscaling_policy_names
}