terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "day26/scalable-web-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
