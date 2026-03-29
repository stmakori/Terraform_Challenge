terraform {
  backend "s3" {
    bucket         = "stephanie-day6-terraform-state-2026-unique"
    key            = "day6/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}