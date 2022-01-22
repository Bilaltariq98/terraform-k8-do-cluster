terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
provider "digitalocean" {}

provider "helm" {
  kubernetes {
    host                   = digitalocean_kubernetes_cluster.development.endpoint
    token                  = digitalocean_kubernetes_cluster.development.kube_config[0].token
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.development.kube_config[0].cluster_ca_certificate)
  }
}
provider "kubernetes" {
  host                   = digitalocean_kubernetes_cluster.development.endpoint
  token                  = digitalocean_kubernetes_cluster.development.kube_config[0].token
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.development.kube_config[0].cluster_ca_certificate)
}