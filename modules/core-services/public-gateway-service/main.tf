module "pubsub-service-account" {
  source = "../../pubsub-service-account"

  project_id   = var.project_id
  namespace    = var.namespace
  service_name = var.service_name
}

resource "google_project_iam_member" "public-gateway-service-account-iam-member" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${module.pubsub-service-account.service_account_email_id}"
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

# Note - AuraDB provisioned manually through https://console.neo4j.io, No terraform provider yet
resource "kubernetes_secret" "admob-ad-unit-ids-secrets" {
  metadata {
    name      = "admob-ad-unit-ids"
    namespace = var.namespace
  }

  data = {
    AD_UNIT_ID_ANDROID = var.ad_unit_id_android
    AD_UNIT_ID_IOS     = var.ad_unit_id_ios
  }
}


module "public-gateway-service-db" {
  source = "../../cloudsql-resources"

  cloud_sql_instance_connection_name = var.cloud_sql_instance_connection_name
  cloud_sql_instance_name            = var.cloud_sql_instance_name
  cloudsql_service_account_key       = var.cloudsql_service_account_key
  database_name                      = var.database_name
  namespace                          = var.namespace
}

