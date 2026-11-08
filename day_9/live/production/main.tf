provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  # Remote module from this repo, pinned to a git ref. Pin to a release tag (e.g. ?ref=v0.0.1) once tagged.
  source = "git::https://github.com/stmakori/terraform-aws-challenge.git//day_9/modules/webserver-cluster?ref=main"

  cluster_name  = "webservers-production"
  instance_type = "t2.medium"
  min_size      = 4
  max_size      = 10
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}