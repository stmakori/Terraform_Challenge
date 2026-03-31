terraform {
  backend "s3" {
    bucket  = "stephanie-day16-terraform-state-2026-secure"
    key     = "day16/dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}