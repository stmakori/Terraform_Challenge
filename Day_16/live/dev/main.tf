provider "aws" {
  region = var.aws_region
}

module "webserver_cluster" {
  source = "../../modules/webserver-cluster"

  project_name  = var.project_name
  team_name     = var.team_name
  environment   = var.environment
  cluster_name  = "day16-web-cluster"
  instance_type = "t3.micro"
  min_size      = 1
  max_size      = 2
  server_port   = 8080
  server_text   = "Hello from Day 16"
}