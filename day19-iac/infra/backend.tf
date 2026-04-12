terraform {
  backend "s3" {
    bucket         = "my-unique-terraform-state-bucket-98765"
    key            = "day19/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
