# Note - GCP project was created manually in the console UI

# Container registry
resource "google_container_registry" "gke-dev-env" {}

# Random service secret for use between image-service and image-proxy
resource "random_string" "image-service-secret" {
  length  = 16
  special = false
}

module "cloudsql-dev-env" {
  source = "../../modules/cloudsql"

  region     = local.region
  project_id = local.project_id
}

module "gke-dev-env" {
  source = "../../modules/kubernetes-cluster"

  project_id = local.project_id
  region     = local.region
  zone       = local.zone
}

module "gke-dev-functional-namespaces" {
  source = "../../modules/kubernetes-namespaces"

  kubernetes_namespaces = local.service_namespaces

  depends_on = [
    module.gke-dev-env
  ]
}

module "gke-dev-shared-resources" {
  source = "../../modules/kubernetes-shared-resources"

  service_namespaces = local.service_namespaces
  image_service_token = random_string.image-service-secret.result

  depends_on = [
    module.gke-dev-functional-namespaces
  ]
}

# Could enable prometheus/grafana via publicURLs with additional config if needed
module "dev-monitoring-stack" {
  source = "../../modules/monitoring-stack"

  depends_on = [
    module.gke-dev-env
  ]
}

# Avoiding NGINX controller for now as there seems to be no easy way to bind to Static IP
module "dev-nginx-ingress-controller" {
  source = "../../modules/nginx-ingress-controller"

  project_id = local.project_id
  region     = local.region

  regional_static_ip_address = module.gke-dev-env.gke_regional_static_ip_address

  depends_on = [
    module.gke-dev-env
  ]
}

# To handle provisioning of TLS certs
module "dev-cert-manager" {
  source = "../../modules/cert-manager"

  depends_on = [
    module.gke-dev-env
  ]
}

# K8s Keycloak server deployment
module "dev-keycloak-server" {
  source = "../../modules/keycloak-server"

  project_id = local.project_id
  region     = local.region

  cloud_sql_instance_name            = module.cloudsql-dev-env.cloudsql_instance_name
  cloud_sql_instance_connection_name = module.cloudsql-dev-env.cloudsql_instance_connection_name
  cloudsql_service_account_key       = module.cloudsql-dev-env.cloudsql_service_account_key

  global_static_ip_name = module.gke-dev-env.gke_regional_static_ip_name
  ssl_policy_name       = module.gke-dev-env.gke_ssl_policy_name

  depends_on = [
    module.gke-dev-env,
    module.cloudsql-dev-env,
  ]
}

# SMTP email intercept for dev env
module "dev-mailhog-server" {
  source = "../../modules/mailhog"

  project_id = local.project_id
  region     = local.region

  depends_on = [
    module.gke-dev-env
  ]
}


# ------------------------------------------------------------------------
module "dev-image-server" {
  source = "../../modules/core-services/go-image-server"

  project_id     = local.project_id
  region         = local.region
  service_secret = random_string.image-service-secret.result

  depends_on = [
    module.gke-dev-env
  ]
}

module "dev-image-proxy-server" {
  source = "../../modules/core-services/go-image-proxy"

  project_id     = local.project_id
  region         = local.region
  service_secret = random_string.image-service-secret.result

  depends_on = [
    module.gke-dev-env
  ]
}
# ------------------------------------------------------------------------

# Create service-account and everything else needed for notification service
module "dev-notification-service" {
  source = "../../modules/core-services/notification-service"

  project_id = local.project_id
  # Note - this output is empty, seems like it need enabling in Firebase console. Perhaps it is not needed though?
  firebase_database_url   = data.terraform_remote_state.tf_remote_state_nonproduction.outputs.firebase_firestore_database_url
  cloud_sql_instance_name = module.cloudsql-dev-env.cloudsql_instance_name
  cloud_sql_instance_connection_name = module.cloudsql-dev-env.cloudsql_instance_connection_name
  cloudsql_service_account_key       = module.cloudsql-dev-env.cloudsql_service_account_key

  firebase_admin_service_account = local.firebase_admin_service_account

  depends_on = [
    module.gke-dev-functional-namespaces,
    module.cloudsql-dev-env,
  ]
}

module "dev-social-service" {
  source = "../../modules/core-services/social-service"

  project_id = local.project_id

  neo4j_db_name  = local.neo4j_db_name
  neo4j_password = local.neo4j_password
  neo4j_uri      = local.neo4j_uri
  neo4j_username = local.neo4j_username

  depends_on = [
    module.gke-dev-functional-namespaces,
  ]

}

module "dev-user-service" {
  source = "../../modules/core-services/user-service"

  project_id = local.project_id

  neo4j_db_name  = local.neo4j_db_name
  neo4j_password = local.neo4j_password
  neo4j_uri      = local.neo4j_uri
  neo4j_username = local.neo4j_username

  cloud_sql_instance_connection_name = module.cloudsql-dev-env.cloudsql_instance_connection_name
  cloud_sql_instance_name            = module.cloudsql-dev-env.cloudsql_instance_name
  cloudsql_service_account_key       = module.cloudsql-dev-env.cloudsql_service_account_key

  depends_on = [
    module.gke-dev-functional-namespaces,
  ]
}

module "dev-chat-service" {
  source = "../../modules/core-services/chat-service"

  project_id = local.project_id

  cloud_sql_instance_connection_name = module.cloudsql-dev-env.cloudsql_instance_connection_name
  cloud_sql_instance_name            = module.cloudsql-dev-env.cloudsql_instance_name
  cloudsql_service_account_key       = module.cloudsql-dev-env.cloudsql_service_account_key

  depends_on = [
    module.gke-dev-functional-namespaces,
  ]
}