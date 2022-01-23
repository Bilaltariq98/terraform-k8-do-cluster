# DO Cluster

Source config is from [here](https://mohsensy.github.io/sysadmin/2021/04/09/install-istio-with-terraform.html)

Used this for the demo app [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-istio-with-kubernetes)

## Prerequiste 
- [Terraform](https://www.terraform.io/downloads)
- [Doctl](https://docs.digitalocean.com/reference/doctl/how-to/install/) 

Set env variable 
$env:DIGITALOCEAN_ACCESS_TOKEN=YOUR ACCESS TOKEN 

```bash
kubectl label namespace default istio-injection=enabled

kubectl apply -f sample-app/manifests/app.yaml -n dev-node-app
kubectl apply -f sample-app/manifests/gateway.yaml -n dev-node-app


```

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
[] Enable OIDC Authentication (keyclock, dex or okta and configure some groups)

Tasks 

- helm-release - pull directly from a https://helm-repo url 
- Bootstrap with keyclock, dex or okta and configure some groups
- configure vault /w secrets 
- Install argo.cd with bootstrapped repositories 