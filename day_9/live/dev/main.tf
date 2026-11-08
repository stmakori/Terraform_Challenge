provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  # Remote module from this repo, pinned to a git ref. Pin to a release tag (e.g. ?ref=v0.0.2) once tagged.
  source = "git::https://github.com/stmakori/terraform-aws-challenge.git//day_9/modules/webserver-cluster?ref=main"

  cluster_name  = "webservers-dev"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 4
  server_text   = "Hello from DEV v0.0.2"
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}