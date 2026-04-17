output "primary_vpc_id" {
  value = module.vpc_primary.vpc_id
}

output "primary_alb_dns" {
  value = module.alb_primary.alb_dns
}

output "primary_asg_name" {
  value = module.asg_primary.asg_name
}