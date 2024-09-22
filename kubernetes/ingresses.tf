# resource "kubernetes_ingress_class" "nginx" {
#   metadata {
#     name = "nginx"
#   }

#   spec {
#       controller = "nginx.org/ingress-controller"
#   }
# }

resource "kubernetes_ingress_v1" "crud" {
  metadata {
    name = "crud-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path     = "/"
          backend {
            service {
              name = kubernetes_service.crud-service.metadata[0].name
              port {
                number = 5000
              }
            }
          }
        }
      }
    }

    rule {
      http {
        path {
          path     = "/items"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.crud-service.metadata[0].name
              port {
                number = 5000
              }
            }
          }
        }
      }
    }
  }
}
