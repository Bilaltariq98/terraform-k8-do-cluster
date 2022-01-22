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