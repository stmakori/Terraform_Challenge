terraform {
  backend "s3" {
    bucket  = "stephanie-day13-terraform-state-2026-secure"
    key     = "day13/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}