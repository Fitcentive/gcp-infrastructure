module "pubsub-service-account" {
  source = "../../pubsub-service-account"

  project_id   = var.project_id
  namespace    = var.namespace
  service_name = var.service_name
}

module "diary-service-db" {
  source = "../../cloudsql-resources"

  cloud_sql_instance_connection_name = var.cloud_sql_instance_connection_name
  cloud_sql_instance_name            = var.cloud_sql_instance_name
  cloudsql_service_account_key       = var.cloudsql_service_account_key
  database_name                      = var.database_name
  namespace                          = var.namespace
}

# Note - Fatsecret credentials provisioned manually through https://platform.fatsecret.com/api/Default.aspx?screen=myc, No terraform provider yet
resource "kubernetes_secret" "diary-service-fatsecret-credentials" {
  metadata {
    name      = "${var.service_name}-fatsecret-credentials"
    namespace = var.namespace
  }

  data = {
    FATSECRET_CLIENT_ID     = var.fatsecret_client_id
    FATSECRET_CLIENT_SECRET = var.fatsecret_client_secret
    FATSECRET_API_HOST      = var.fatsecret_api_host
    FATSECRET_AUTH_HOST     = var.fatsecret_auth_host
  }
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
