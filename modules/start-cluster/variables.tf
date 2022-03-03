
variable "do_cluster_name" {
  type        = string
  description = "Name of the kubernetes cluster"
}
variable "do_region" {
  type        = string
  description = "region of K8s DO Cluster"
}

variable "do_k8_version" {
  type        = string
  description = "Kubernetes Version from DO"
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}