# Note - AuraDB is provisioned through the console. Can be accessed at https://console.neo4j.io/
module "pubsub-service-account" {
  source = "../../pubsub-service-account"

  project_id   = var.project_id
  namespace    = var.namespace
  service_name = var.service_name
}