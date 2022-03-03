resource "kubernetes_namespace" "dev-node-app" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "dev-node-app"
  }
}

resource "kubernetes_manifest" "node-svc" {
  manifest = {
    "apiVersion" : "v1",
    "kind" : "Service",
    "metadata" : {
      "namespace" : "dev-node-app",
      "name" : "nodejs",
      "labels" : {
        "app" : "nodejs"
      }
    },
    "spec" : {
      "selector" : {
        "app" : "nodejs"
      },
      "ports" : [
        {
          "name" : "http",
          "port" : 8080
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "node-deployment" {
  manifest = {
    "apiVersion" : "apps/v1",
    "kind" : "Deployment",
    "metadata" : {
      "namespace" : "dev-node-app",
      "name" : "nodejs",
      "labels" : {
        "version" : "v1"
      }
    },
    "spec" : {
      "replicas" : 1,
      "selector" : {
        "matchLabels" : {
          "app" : "nodejs"
        }
      },
      "template" : {
        "metadata" : {
          "labels" : {
            "app" : "nodejs",
            "version" : "v1"
          }
        },
        "spec" : {
          "containers" : [
            {
              "name" : "nodejs",
              "image" : "bilal690/node-demo",
              "ports" : [
                {
                  "containerPort" : 8080
                }
              ]
            }
          ]
        }
      }
    }
  }

}

resource "kubernetes_manifest" "node-gateway" {
  manifest = {
    "apiVersion" : "networking.istio.io/v1alpha3",
    "kind" : "Gateway",
    "metadata" : {
      "namespace" : "dev-node-app",
      "name" : "nodejs-gateway"
    },
    "spec" : {
      "selector" : {
        "istio" : "ingressgateway"
      },
      "servers" : [
        {
          "port" : {
            "number" : 80,
            "name" : "http",
            "protocol" : "HTTP"
          },
          "hosts" : [
            "*"
          ]
        }
      ]
    }
  }

}

resource "kubernetes_manifest" "node-virtual-svc" {
  manifest = {
    "apiVersion" : "networking.istio.io/v1alpha3",
    "kind" : "VirtualService",
    "metadata" : {
      "namespace" : "dev-node-app",
      "name" : "nodejs"
    },
    "spec" : {
      "hosts" : [
        "*"
      ],
      "gateways" : [
        "nodejs-gateway"
      ],
      "http" : [
        {
          "route" : [
            {
              "destination" : {
                "host" : "nodejs"
              }
            }
          ]
        }
      ]
    }
  }

}