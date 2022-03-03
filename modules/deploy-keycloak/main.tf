resource "kubernetes_namespace" "keycloak" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }
    name = "keycloak"
  }
}

resource "kubernetes_manifest" "keycloak-svc" {
  manifest = {
    "apiVersion" : "v1",
    "kind" : "Service",
    "metadata" : {
      "namespace" : "keycloak",
      "name" : "keycloak",
      "labels" : {
        "app" : "keycloak"
      }
    },
    "spec" : {
      "selector" : {
        "app" : "keycloak"
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

resource "kubernetes_manifest" "keycloak-deployment" {
  manifest = {
    "apiVersion" : "apps/v1",
    "kind" : "Deployment",
    "metadata" : {
      "namespace" : "keycloak",
      "name" : "keycloak"
    },
    "spec" : {
      "replicas" : 1,
      "selector" : {
        "matchLabels" : {
          "app" : "keycloak"
        }
      },
      "template" : {
        "metadata" : {
          "labels" : {
            "app" : "keycloak"
          }
        },
        "spec" : {
          "containers" : [
            {
              "name" : "keycloak",
              "image" : "quay.io/keycloak/keycloak:16.1.0",
              "env" : [
                {
                  "name" : "KEYCLOAK_USER",
                  "value" : "${var.keycloak_username}"
                },
                {
                  "name" : "KEYCLOAK_PASSWORD",
                  "value" : "${random_password.keycloak_password}"
                }
              ],
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

resource "kubernetes_manifest" "keycloak-gateway" {
  manifest = {
    "apiVersion" : "networking.istio.io/v1alpha3",
    "kind" : "Gateway",
    "metadata" : {
      "namespace" : "keycloak",
      "name" : "keycloak-gateway"
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

resource "kubernetes_manifest" "keycloak-virtual-svc" {
  manifest = {
    "apiVersion" : "networking.istio.io/v1alpha3",
    "kind" : "VirtualService",
    "metadata" : {
      "namespace" : "keycloak",
      "name" : "keycloak"
    },
    "spec" : {
      "hosts" : [
        "*"
      ],
      "gateways" : [
        "keycloak-gateway"
      ],
      "http" : [
        {
          "match" : [
            {
              "uri" : {
                "prefix" : "/auth"
              }
            }
          ],
          "route" : [
            {
              "destination" : {
                "host" : "keycloak",
                "port" : {
                  "number" : 80
                }
              }
            }
          ]
        }
      ]
    }
  }

}