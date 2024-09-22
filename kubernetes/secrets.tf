resource "kubernetes_secret_v1" "postgres" {
  metadata {
    name = "postgresql-secret"
  }

  data = {
    POSTGRES_USER = var.postgres_username
    POSTGRES_PASSWORD = var.postgres_password
    POSTGRES_DB = var.postgres_db_name
    POSTGRES_SERVICE = var.postgres_service

  }
}