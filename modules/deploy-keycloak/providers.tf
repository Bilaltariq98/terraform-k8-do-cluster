terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  host                   = var.host
  token                  = var.token
  cluster_ca_certificate = var.cluster_ca_certificate
}

# provider "keycloak" {
#   client_id = "admin-cli"
#   username  = var.keycloak_username
#   password  = random_password.keycloak_password
#   // see docker-compose.yml
#   url       = "http://keycloak:8080"
# }