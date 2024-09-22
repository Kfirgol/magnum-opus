variable "postgres_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "postgres_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "postgres_db_name" {
  description = "Database name"
  type        = string
  sensitive   = false
  default = "mydb"
}

variable "postgres_service" {
  description = "Database service name"
  type        = string
  sensitive   = false
  default = "postgresql-service"
}
