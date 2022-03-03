##################################################################################
# Cluster Setup
##################################################################################
resource "digitalocean_kubernetes_cluster" "development" {
  name    = var.do_cluster_name
  region  = var.do_region
  version = var.do_k8_version

  node_pool {
    name       = "node-pool-${random_integer.rand.result}"
    size       = "s-2vcpu-4gb"
    node_count = 4
  }

  provisioner "local-exec" {
    command     = "doctl kubernetes cluster kubeconfig save ${self.id}"
    interpreter = ["PowerShell", "-Command"]
  }
}
##################################################################################
# Container Registry  
##################################################################################
resource "digitalocean_container_registry" "testbed" {
  name                   = "testbed-${random_integer.rand.result}"
  subscription_tier_slug = "starter"
}

resource "digitalocean_container_registry_docker_credentials" "testbed" {
  registry_name = digitalocean_container_registry.testbed.name
}

resource "kubernetes_secret" "dockercfg" {
  metadata {
    name = "docker-cfg"
  }

  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.testbed.docker_credentials
  }

  type = "kubernetes.io/dockerconfigjson"
}
##################################################################################
# ISTIO 
##################################################################################
resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  name  = "istio-base"
  chart = "istio-1.9.2/manifests/charts/base"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-system"


  depends_on = [digitalocean_kubernetes_cluster.development, kubernetes_namespace.istio_system]
}

resource "helm_release" "istiod" {
  name  = "istiod"
  chart = "istio-1.9.2/manifests/charts/istio-control/istio-discovery"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-system"

  depends_on = [digitalocean_kubernetes_cluster.development, kubernetes_namespace.istio_system, helm_release.istio_base]
}

resource "helm_release" "istio_egress" {
  name  = "istio-egress"
  chart = "istio-1.9.2/manifests/charts/gateways/istio-egress"

  timeout         = 240
  cleanup_on_fail = true
  force_update    = true
  namespace       = "istio-system"

  depends_on = [digitalocean_kubernetes_cluster.development, kubernetes_namespace.istio_system, helm_release.istiod]
}

resource "helm_release" "istio_ingress" {
  name  = "istio-ingress"
  chart = "istio-1.9.2/manifests/charts/gateways/istio-ingress"

  timeout         = 300
  cleanup_on_fail = false
  force_update    = true
  namespace       = "istio-system"

  set {
    name  = "controller.replicaCount"
    value = "1"
  }

  depends_on = [digitalocean_kubernetes_cluster.development, kubernetes_namespace.istio_system, helm_release.istiod]
}