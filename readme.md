# DO Cluster

Source config is from [here](https://mohsensy.github.io/sysadmin/2021/04/09/install-istio-with-terraform.html)

Used this for the demo app [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-istio-with-kubernetes)

## Prerequiste 
- [Terraform](https://www.terraform.io/downloads)
- [Doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/) 


```yaml
# Update istio-x.x.x\manifests\charts\gateways\istio-ingress\templates\deployment.yaml
# This allows us to use ngrok as a reverse tunnel for the load balancer (as the cluster is short lived)
containers:
- name: ngrok
    image: ngrok/ngrok
    command: ["ngrok http 8080 -authtoken <authToken>"]
```

Achieved:
[x] Create a DO Kubernetes cluster 
[x] Use istio as a service mesh 
[x] Deploy a test app to istio 
[] Enable Grafana, Promethus and Kiali
[] Configure istio (sub-domain based stuff)
[] Create K8s RBAC Policies
[] Enable OIDC Authentication (keycloak, dex or okta and configure some groups)

Other things to do 

- helm-release - pull directly from a https://helm-repo url rather than locally pulled istio files 
- Configure vault /w secrets
    - DO Registry Credentials 
    - GitLab Secret
    - DB Rolling Credentials (kinda complex)
- Configure a GitLab CI Runner for CI  
- Configure Argo.CD 



Random Notes:

### [keycloak](https://www.youtube.com/watch?v=nPZ8QDZXtLI) 

You can curl the token with a different grant directly to get an id_token back
```bash
curl -X POST http://host-url:port/auth/realms/realm/protocol/openid-connect/token \ 
        -d grant_type=password \
        -d client_id=some_client \
        -d username=admin \ 
        -d password=admin \ 
        | jq -r '.access_token' 
```

Sharing inputs between modules may be desirable
https://terragrunt.gruntwork.io/ 


# Prepare config
terraform init
terraform fmt -recursive
terraform validate

# For Linux and MacOS
export DIGITALOCEAN_ACCESS_TOKEN=YOUR ACCESS TOKEN 

# For PowerShell
$env:DIGITALOCEAN_ACCESS_TOKEN=YOUR ACCESS TOKEN


# Start the cluster
terraform apply -target="module.do_k8_cluster"

# Deploy other modules
terraform apply