provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "github.com/your-username/terraform-aws-webserver-cluster?ref=v0.0.2"

  cluster_name  = "webservers-dev"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 4
  server_text   = "Hello from DEV v0.0.2"
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}