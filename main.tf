
module "do_k8_cluster" {
  source = "./modules/start-cluster"

  do_cluster_name = "development"
  do_region       = "lon1"
  do_k8_version   = "1.21.5-do.0"
}

module "keycloak" {
  source = "./modules/deploy-keycloak"

  host                   = module.do_k8_cluster.host
  token                  = module.do_k8_cluster.token
  cluster_ca_certificate = module.do_k8_cluster.cluster_ca_certificate

  # depends_on = [do_k8_cluster]
}

module "deploy_node" {
  source = "./modules/deploy-node"

  host                   = module.do_k8_cluster.host
  token                  = module.do_k8_cluster.token
  cluster_ca_certificate = module.do_k8_cluster.cluster_ca_certificate

  # depends_on = [do_k8_cluster]
}

