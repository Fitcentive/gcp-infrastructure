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


module "gke-dev-functional-namespaces" {
  source = "../../modules/kubernetes-namespaces"

  kubernetes_namespaces = local.service_namespaces

}

module "gke-dev-shared-resources" {
  source = "../../modules/kubernetes-shared-resources"

  service_namespaces  = local.service_namespaces
  image_service_token = random_string.image-service-secret.result

  depends_on = [
    module.gke-dev-functional-namespaces
  ]
}

# Could enable prometheus/grafana via publicURLs with additional config if needed
# Monitoring stack disabled to save on CPU/Mem resources
# Node level metrics can be found in the GCP console at https://console.cloud.google.com/kubernetes/clusters/details/northamerica-northeast2-a/fitcentive-dev-gke/nodes?authuser=1&orgonly=true&project=fitcentive-dev&supportedpurview=organizationId,folder,project
#
#module "dev-monitoring-stack" {
#  source = "../../modules/monitoring-stack"
#
#}

#
# ----------------------------------------------------------------
# Sometimes, deleting a namespace is hard due to finalizers
# In such situations, use the following
# kubectl proxy
# In another tab... do,
# kubectl get ns nginx -o json | jq '.spec.finalizers=[]' | curl -X PUT http://localhost:8001/api/v1/namespaces/nginx/finalize -H "Content-Type: application/json" --data @-
# ----------------------------------------------------------------
module "dev-nginx-ingress-controller" {
  source = "../../modules/nginx-ingress-controller"

  project_id = local.project_id
  region     = local.region

  regional_static_ip_address = data.terraform_remote_state.tf_remote_state_nonproduction.outputs.gke_dev_gke_regional_static_ip_address

}

# To handle provisioning of TLS certs
module "dev-cert-manager" {
  source = "../../modules/cert-manager"
}

# K8s Keycloak server deployment
module "dev-keycloak-server" {
  source = "../../modules/keycloak-server"

  project_id = local.project_id
  region     = local.region

  cloud_sql_instance_name            = module.cloudsql-dev-env.cloudsql_instance_name
  cloud_sql_instance_connection_name = module.cloudsql-dev-env.cloudsql_instance_connection_name
  cloudsql_service_account_key       = module.cloudsql-dev-env.cloudsql_service_account_key

  global_static_ip_name = data.terraform_remote_state.tf_remote_state_nonproduction.outputs.gke_dev_gke_regional_static_ip_name
  ssl_policy_name       = data.terraform_remote_state.tf_remote_state_nonproduction.outputs.gke_dev_gke_ssl_policy_name
  keycloak_server_host  = "auth.fitcentive.xyz"

  depends_on = [
    module.cloudsql-dev-env,
  ]
}

# SMTP email intercept for dev env
module "dev-mailhog-server" {
  source = "../../modules/mailhog"

  project_id = local.project_id
  region     = local.region

}


# ------------------------------------------------------------------------
module "dev-image-server" {
  source = "../../modules/core-services/go-image-server"

  project_id     = local.project_id
  region         = local.region
  service_secret = random_string.image-service-secret.result

  image_service_bucket_name = "${local.project_id}-image-service-upload-images"

}

module "dev-image-proxy-server" {
  source = "../../modules/core-services/go-image-proxy"

  project_id     = local.project_id
  region         = local.region
  service_secret = random_string.image-service-secret.result

}
# ------------------------------------------------------------------------

# Create service-account and everything else needed for notification service
module "dev-notification-service" {
  source = "../../modules/core-services/notification-service"

  project_id = local.project_id
  # Note - this output is empty, seems like it need enabling in Firebase console. Perhaps it is not needed though?
  firebase_database_url              = data.terraform_remote_state.tf_remote_state_nonproduction.outputs.firebase_firestore_database_url
  cloud_sql_instance_name            = module.cloudsql-dev-env.cloudsql_instance_name
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

module "dev-discover-service" {
  source = "../../modules/core-services/discover-service"

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
    module.cloudsql-dev-env,
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
    module.cloudsql-dev-env,
  ]
}

module "dev-chat-service" {
  source = "../../modules/core-services/chat-service"

  project_id = local.project_id

  cloud_sql_instance_connection_name = module.cloudsql-dev-env.cloudsql_instance_connection_name
  cloud_sql_instance_name            = module.cloudsql-dev-env.cloudsql_instance_name
  cloudsql_service_account_key       = module.cloudsql-dev-env.cloudsql_service_account_key

  apple_auth_key_id        = local.apple_auth_key_id
  apple_auth_public_key    = local.apple_auth_public_key
  auth_server_url          = local.auth_server_url
  facebook_auth_key_id     = local.facebook_auth_key_id
  facebook_auth_public_key = local.facebook_auth_public_key
  google_auth_key_id       = local.google_auth_key_id
  google_auth_public_key   = local.google_auth_public_key
  native_auth_key_id       = local.native_auth_key_id
  native_auth_public_key   = local.native_auth_public_key

  depends_on = [
    module.gke-dev-functional-namespaces,
    module.cloudsql-dev-env,
  ]
}

module "dev-auth-service" {
  source = "../../modules/core-services/auth-service"

  project_id                     = local.project_id
  keycloak_admin_client_password = local.keycloak_admin_client_password
  keycloak_admin_client_id       = local.keycloak_admin_client_id
  keycloak_admin_client_username = local.keycloak_admin_client_username
  keycloak_admin_client_secret   = local.keycloak_admin_client_secret


  depends_on = [
    module.gke-dev-functional-namespaces,
  ]
}

module "dev-meetup-service" {
  source = "../../modules/core-services/meetup-service"

  project_id = local.project_id

  cloud_sql_instance_connection_name = module.cloudsql-dev-env.cloudsql_instance_connection_name
  cloud_sql_instance_name            = module.cloudsql-dev-env.cloudsql_instance_name
  cloudsql_service_account_key       = module.cloudsql-dev-env.cloudsql_service_account_key

  depends_on = [
    module.gke-dev-functional-namespaces,
    module.cloudsql-dev-env,
  ]
}

module "dev-diary-service" {
  source = "../../modules/core-services/diary-service"

  project_id = local.project_id

  cloud_sql_instance_connection_name = module.cloudsql-dev-env.cloudsql_instance_connection_name
  cloud_sql_instance_name            = module.cloudsql-dev-env.cloudsql_instance_name
  cloudsql_service_account_key       = module.cloudsql-dev-env.cloudsql_service_account_key

  fatsecret_client_id     = local.fatsecret_client_id
  fatsecret_client_secret = local.fatsecret_client_secret

  depends_on = [
    module.gke-dev-functional-namespaces,
    module.cloudsql-dev-env,
  ]
}

module "dev-scheduler-service" {
  source = "../../modules/core-services/scheduler-service"

  project_id = local.project_id

  cloud_sql_instance_connection_name = module.cloudsql-dev-env.cloudsql_instance_connection_name
  cloud_sql_instance_name            = module.cloudsql-dev-env.cloudsql_instance_name
  cloudsql_service_account_key       = module.cloudsql-dev-env.cloudsql_service_account_key


  depends_on = [
    module.gke-dev-functional-namespaces,
    module.cloudsql-dev-env,
  ]
}