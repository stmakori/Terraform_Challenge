module "static_site" {
  source = "../../modules/s3-static-website"

  bucket_name = var.bucket_name
  environment = var.environment

  tags = {
    Project = "day25"
  }
}
