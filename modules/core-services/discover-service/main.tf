module "discover-service-db" {
  source = "../../cloudsql-resources"

  cloud_sql_instance_connection_name = var.cloud_sql_instance_connection_name
  cloud_sql_instance_name            = var.cloud_sql_instance_name
  cloudsql_service_account_key       = var.cloudsql_service_account_key
  database_name                      = var.database_name
  namespace                          = var.namespace
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
