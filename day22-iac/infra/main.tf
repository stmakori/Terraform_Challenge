module "webserver" {
  source = "../modules/webserver"

  instance_type = var.instance_type

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
