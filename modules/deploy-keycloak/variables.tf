variable "keycloak_username" {
  type        = string
  description = "Username for keycloak"
  default     = "admin"
}

resource "random_password" "keycloak_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

variable "host" {
  type        = string
  description = "Kubernetes Host"
  sensitive   = true
}
variable "token" {
  type        = string
  description = "Kubernetes Token"
  sensitive   = true
}
variable "cluster_ca_certificate" {
  type        = string
  description = "Cluster CA Cert"
  sensitive   = true
}

