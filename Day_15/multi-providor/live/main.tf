terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

provider "aws" {
  alias  = "replica"
  region = "us-west-2"
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "multi_region_app" {
  source   = "../modules/multi-region-app"
  app_name = "day15-app-${random_id.suffix.hex}"

  providers = {
    aws.primary = aws.primary
    aws.replica = aws.replica
  }
}

output "primary_bucket_name" {
  value = module.multi_region_app.primary_bucket_name
}

output "replica_bucket_name" {
  value = module.multi_region_app.replica_bucket_name
}