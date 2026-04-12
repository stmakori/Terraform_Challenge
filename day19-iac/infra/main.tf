resource "aws_s3_bucket" "example_bucket" {
  bucket = "day19-iac-demo-bucket-12345"

  tags = {
    Name        = "Day19Bucket"
    Environment = "Dev"
  }
}
