output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "nginx_namespace" {
  value = kubernetes_namespace.apps.metadata[0].name
}

output "nginx_service_name" {
  value = kubernetes_service.nginx.metadata[0].name
}