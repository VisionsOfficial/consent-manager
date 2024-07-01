output "consent_manager_service_ip" {
  value = kubernetes_service.consent_manager.status[0].load_balancer[0].ingress[0].ip
}

output "consent_manager_namespace" {
  value = kubernetes_namespace.consent_manager.metadata[0].name
}
