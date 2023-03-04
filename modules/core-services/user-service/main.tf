module "pubsub-service-account" {
  source = "../../pubsub-service-account"

  project_id   = var.project_id
  namespace    = var.namespace
  service_name = var.service_name
}

module "user-service-db" {
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

# Create and push custom gcloud docker image to publish to topic
resource "null_resource" "push_custom_gcloud_user_docker_image_publish_to_pubsubs" {
  provisioner "local-exec" {
    command = <<-EOT
      docker build -t gcloud-user-cron-pubsub-image:latest -t gcloud-user-cron-pubsub-image:1.0 ${path.module}/resources/
      docker tag gcloud-user-cron-pubsub-image:1.0 gcr.io/${var.project_id}/gcloud-user-cron-pubsub-image:1.0
      docker push gcr.io/${var.project_id}/gcloud-user-cron-pubsub-image:1.0
    EOT
  }
}


# Note - AuraDB provisioned manually through https://console.neo4j.io, No terraform provider yet
resource "kubernetes_secret" "neo4j-secrets" {
  metadata {
    name      = "neo4j-secrets"
    namespace = var.namespace
  }

  data = {
    NEO4J_URI           = var.neo4j_uri
    NEO4J_USERNAME      = var.neo4j_username
    NEO4J_PASSWORD      = var.neo4j_password
    NEO4J_INSTANCE_NAME = var.neo4j_db_name
  }
}

