module "pubsub-service-account" {
  source = "../../pubsub-service-account"

  project_id   = var.project_id
  namespace    = var.namespace
  service_name = var.service_name
}

module "awards-service-db" {
  source = "../../cloudsql-resources"

  cloud_sql_instance_connection_name = var.cloud_sql_instance_connection_name
  cloud_sql_instance_name            = var.cloud_sql_instance_name
  cloudsql_service_account_key       = var.cloudsql_service_account_key
  database_name                      = var.database_name
  namespace                          = var.namespace
}

resource "kubernetes_config_map_v1" "service-account-config-map" {
  metadata {
    name      = "${var.service_name}-service-account"
    namespace = var.namespace
  }

  data = {
    "key.json" = base64decode(module.pubsub-service-account.service_account_key)
  }
}
