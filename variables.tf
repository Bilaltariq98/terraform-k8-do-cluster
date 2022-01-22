
variable "do_cluster_name" {
  type        = string
  description = "Name of the kubernetes cluster"
  default     = "development"
}
variable "do_region" {
  type        = string
  description = "region of K8s DO Cluster"
  default     = "lon1"
}

variable "do_k8_version" {
  type        = string
  description = "Kubernetes Version from DO"
  default     = "1.21.5-do.0"
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}