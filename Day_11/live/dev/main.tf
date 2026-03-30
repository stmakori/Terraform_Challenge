provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../modules/webserver-cluster"

  cluster_name               = "webservers-dev"
  environment                = "dev"
  server_text                = "Hello from Day 11 DEV"
  enable_detailed_monitoring = false
  create_dns_record          = false
  use_existing_vpc           = true

  common_tags = {
    Owner = "Stephanie"
    Day   = "11"
  }
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}

output "instance_type" {
  value = module.webserver_cluster.instance_type
}

output "cluster_sizes" {
  value = module.webserver_cluster.cluster_sizes
}

output "alarm_arn" {
  value = module.webserver_cluster.alarm_arn
}