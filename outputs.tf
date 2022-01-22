output "kubectl-connection-string" {
  value = "doctl kubernetes cluster kubeconfig save ${digitalocean_kubernetes_cluster.development.id}"
}