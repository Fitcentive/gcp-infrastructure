module "pubsub-service-account" {
  source = "../../pubsub-service-account"

  project_id   = var.project_id
  namespace    = var.namespace
  service_name = var.service_name
}

module "scheduler-service-db" {
  source = "../../cloudsql-resources"

  cloud_sql_instance_connection_name = var.cloud_sql_instance_connection_name
  cloud_sql_instance_name            = var.cloud_sql_instance_name
  cloudsql_service_account_key       = var.cloudsql_service_account_key
  database_name                      = var.database_name
  namespace                          = var.namespace
}