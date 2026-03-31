output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}

output "asg_name" {
  value = module.webserver_cluster.asg_name
}

output "alerts_topic_arn" {
  value = module.webserver_cluster.alerts_topic_arn
}

output "log_bucket_name" {
  value = module.webserver_cluster.log_bucket_name
}