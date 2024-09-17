resource "kubernetes_deployment" "nginx" {
  depends_on = [kubernetes_deployment.crud, kubernetes_service.crud-service]
  metadata {
    namespace = "default"
    name      = "nginx-deployment"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "public.ecr.aws/o3q3p0r1/nginx:latest"
          name  = "nginx"

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


resource "kubernetes_deployment" "crud" {
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
  metadata {
    name = "postgresql"
    labels = {
      app = "postgresql"
    }

  }

  spec {
    replicas     = 2
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
        # service_account_name = "postgresql"
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

