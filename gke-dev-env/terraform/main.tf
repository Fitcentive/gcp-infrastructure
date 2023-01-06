# Note - GCP project was created manually in the console UI

# Container registry
resource "google_container_registry" "gke-dev-env" {}

# Random service secret for use between image-service and image-proxy
resource "random_string" "image-service-secret" {
  length  = 16
  special = false
}


module "dev-firebase-project" {
  source = "../../modules/firebase"

  project_id       = local.project_id
  default_location = local.firebase_location
}

module "cloudsql-dev-env" {
  source = "../../modules/cloudsql"

  region     = local.region
  project_id = local.project_id
}


# GKE cluster - we might have to move this to a parent resource, as the provider scope references the state which is yet to be created
# Easy fix, target apply this resource first
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
  firebase_database_url   = module.dev-firebase-project.firestore_database_url
  cloud_sql_instance_name = module.cloudsql-dev-env.cloudsql_instance_name
  cloud_sql_instance_connection_name = module.cloudsql-dev-env.cloudsql_instance_connection_name
  cloudsql_service_account_key       = module.cloudsql-dev-env.cloudsql_service_account_key

  # Note - the following value is fetched from https://console.firebase.google.com/u/1/project/place-2-meet-dev/settings/serviceaccounts/adminsdk
  # This value is created when `module.dev-firebase-project` is executed successfully
  # Refer to the README.adoc for more info on how to set this value appropriately
  firebase_admin_service_account = "firebase-adminsdk-j7w3s"

  depends_on = [
    module.gke-dev-functional-namespaces,
    module.dev-firebase-project,
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