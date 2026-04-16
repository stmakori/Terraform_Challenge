module "network" {
  source      = "../../modules/network"
  environment = "dev"
}

module "ec2" {
  source      = "../../modules/ec2"
  ami_id      = var.ami_id
  vpc_id      = module.network.vpc_id
  environment = "dev"
}

module "alb" {
  source            = "../../modules/alb"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}

module "asg" {
  source                  = "../../modules/asg"
  launch_template_id      = module.ec2.launch_template_id
  launch_template_version = module.ec2.launch_template_version
  public_subnet_ids       = module.network.public_subnet_ids
  target_group_arns       = [module.alb.target_group_arn]
}
