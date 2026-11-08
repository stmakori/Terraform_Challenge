module "vpc_primary" {
  source = "../../modules/vpc"

  vpc_cidr             = "10.0.0.0/16"
  environment          = "prod"
  region               = "us-east-1"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]

  providers = {
    aws = aws.primary
  }
}

module "alb_primary" {
  source = "../../modules/alb"

  name        = "app-primary"
  vpc_id      = module.vpc_primary.vpc_id
  subnet_ids  = module.vpc_primary.public_subnets
  environment = "prod"
  region      = "us-east-1"

  providers = {
    aws = aws.primary
  }
}

module "asg_primary" {
  source = "../../modules/asg"

  ami_id            = "ami-0c02fb55956c7d316"
  vpc_id            = module.vpc_primary.vpc_id
  subnet_ids        = module.vpc_primary.private_subnets
  target_group_arns = [module.alb_primary.tg_arn]
  alb_sg            = module.alb_primary.sg_id
  environment       = "prod"
  region            = "us-east-1"

  providers = {
    aws = aws.primary
  }
}
