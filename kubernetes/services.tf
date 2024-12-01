resource "kubernetes_service" "postgresql-service" {
  depends_on = [kubernetes_stateful_set.postgresql]
  metadata {
    name = "postgresql-service"
  }
  spec {
    selector = {
      app = "postgresql"
    }
    port {
      port        = 27017
      target_port = 27017
    }
    cluster_ip = "None"
  }
}


resource "kubernetes_service" "crud-service" {
  depends_on = [kubernetes_deployment.crud]
  metadata {
    name = "crud-service"
  }
  spec {
    selector = {
      app = "crud"
    }
    port {
      port        = 5000
      target_port = 5000
    }
    type = "ClusterIP"
  }
}