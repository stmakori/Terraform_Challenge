provider "aws" {
  region = "us-east-1"
}

module "zero_downtime_cluster" {
  source = "../modules/zero-downtime-cluster"

  cluster_name       = "day12-webserver"
  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  app_version        = "v1"
  active_environment = "blue"
}

output "alb_dns_name" {
  value = module.zero_downtime_cluster.alb_dns_name
}

output "active_environment" {
  value = module.zero_downtime_cluster.active_environment
}