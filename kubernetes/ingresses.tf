resource "kubernetes_ingress_v1" "postgresql" {
  depends_on = [kubernetes_deployment.nginx]
  metadata {
    name = "postgresql"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/query"
          backend {
            service {
              name = kubernetes_service.postgresql-service.metadata.0.name
              port {
                number = 27017
              }
            }

          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "lb-ingress-https" {
  wait_for_load_balancer = true
  depends_on             = [kubernetes_service.nginx-service]
  metadata {
    name = "lb-ingress"
    annotations = {
      ingress_class_name = "nginx"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/certificate-arn" = "arn:aws:acm-pca:us-east-1:590183844603:certificate-authority/d8643332-9223-45ee-8da2-eea22f59520f"
    }
  }
  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = kubernetes_service.nginx-service.metadata.0.name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
    tls {

    }
  }
}