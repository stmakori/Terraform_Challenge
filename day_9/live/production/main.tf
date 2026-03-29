provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "github.com/your-username/terraform-aws-webserver-cluster?ref=v0.0.1"

  cluster_name  = "webservers-production"
  instance_type = "t2.medium"
  min_size      = 4
  max_size      = 10
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}