module "pubsub-service-account" {
  source = "../../pubsub-service-account"

  project_id   = var.project_id
  namespace    = var.namespace
  service_name = var.service_name
}

module "chat-service-db" {
  source = "../../cloudsql-resources"

  cloud_sql_instance_connection_name = var.cloud_sql_instance_connection_name
  cloud_sql_instance_name            = var.cloud_sql_instance_name
  cloudsql_service_account_key       = var.cloudsql_service_account_key
  database_name                      = var.database_name
  namespace                          = var.namespace
}

resource "kubernetes_secret" "chat-cloudsql-database-url" {
  metadata {
    name      = "${var.namespace}-service-cloudsql-database-url"
    namespace = var.namespace
  }

  data = {
    DATABASE_URL = "ecto://${module.chat-service-db.cloudsql_instance_username}:${module.chat-service-db.cloudsql_instance_password}}@localhost:5432/${module.chat-service-db.cloudsql_database_name}}"
  }

}