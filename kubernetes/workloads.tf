# resource "kubernetes_deployment" "nginx" {
#   depends_on = [kubernetes_deployment.crud, kubernetes_service.crud-service, kubernetes_cluster_role_binding_v1.nginx-role-binding]
#   metadata {
#     namespace = "default"
#     name      = "nginx-deployment"
#     labels = {
#       app = "nginx"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "nginx"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "nginx"
#         }
#       }

#       spec {
#         service_account_name = kubernetes_service_account.nginx-sa.metadata[0].name
#         container {
#           image = "public.ecr.aws/o3q3p0r1/nginx-ingress-controller:latest"
#           name  = "nginx"
#           port {
#             container_port = 80
#           }

#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests = {
#               cpu    = "250m"
#               memory = "50Mi"
#             }
#           }
#         }
#       }
#     }
#   }
# }


resource "kubernetes_deployment" "crud" {
  depends_on = [ kubernetes_secret_v1.postgres ]
  metadata {
    namespace = "default"
    name      = "crud-deployment"
    labels = {
      app = "crud"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "crud"
      }
    }

    template {
      metadata {
        labels = {
          app = "crud"
        }
      }

      spec {
        container {
          image = "public.ecr.aws/o3q3p0r1/crud:latest"
          name  = "crud"
          port {
            container_port = 5000
          }
          env_from {
            secret_ref {
              name = "postgresql-secret"
            }
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}



resource "kubernetes_stateful_set" "postgresql" {
  depends_on = [ kubernetes_secret_v1.postgres ]
  metadata {
    name = "postgresql"
    labels = {
      app = "postgresql"
    }

  }

  spec {
    replicas     = 1
    service_name = "postgresql"

    selector {
      match_labels = {
        app = "postgresql"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgresql"
        }
      }

      spec {
        container {
          name  = "postgresql"
          image = "postgres:latest"
          env_from {
            secret_ref {
              name = "postgresql-secret"
            }
          }
          port {
            container_port = "5432"
          }
        }


      }
    }

  }
}

