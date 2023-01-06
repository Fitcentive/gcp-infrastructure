# Note - AuraDB is provisioned through the console. Can be accessed at https://console.neo4j.io/
module "pubsub-service-account" {
  source = "../../pubsub-service-account"

  project_id   = var.project_id
  namespace    = var.namespace
  service_name = var.service_name
}

# Note - AuraDB provisioned manually through https://console.neo4j.io, No terraform provider yet
resource "kubernetes_secret" "neo4j-secrets" {
  metadata {
    name      = "neo4j-secrets"
    namespace = var.namespace
  }

  data = {
    NEO4J_URI          = var.neo4j_uri
    NEO4J_USERNAME     = var.neo4j_username
    NEO4J_PASSWORD     = var.neo4j_password
    NEO4J_INSTANCE_NAME = var.neo4j_db_name
  }
}