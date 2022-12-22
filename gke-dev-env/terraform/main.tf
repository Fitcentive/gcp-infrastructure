# Terraform state bucket
# Might have to tf import separately
resource "google_storage_bucket" "terraform-remote-state-bucket" {
  name          = "p2m-tf-state-dev"
  force_destroy = false
  location      = local.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Container registry
resource "google_container_registry" "gke-dev-env" {}

module "cloudsql-dev-env" {
  source = "../../modules/cloudsql"

  region     = local.region
  project_id = local.project_id
}


# GKE cluster - we might have to move this to a parent resource, as the provider scope references the state which is yet to be created
# Easy fix, target apply this resource first
module "gke-dev-env" {
  source     = "../../modules/kubernetes-cluster"

  project_id = local.project_id
  region     = local.region
  zone       = local.zone
}

module "gke-dev-functional-namespaces" {
  source = "../../modules/kubernetes-namespaces"

  kubernetes_namespaces = local.functional_namespaces

  depends_on = [
    module.gke-dev-env
  ]
}

module "gke-dev-shared-secrets" {
  source = "../../modules/kubernetes-shared-secrets"

  kubernetes_namespaces = local.functional_namespaces

  depends_on = [
    module.gke-dev-functional-namespaces
  ]
}

# Avoiding NGINX controller for now as there seems to be no easy way to bind to Static IP
#module "dev-nginx-ingress-controller" {
#  source = "../../modules/nginx-ingress-controller"
#
#  project_id = local.project_id
#  region     = local.region
#}

# K8s Keycloak server deployment
module "dev-keycloak-server" {
  source = "../../modules/keycloak-server"

  project_id = local.project_id
  region     = local.region

  cloud_sql_instance_name                 = module.cloudsql-dev-env.cloudsql_instance_name
  cloud_sql_instance_connection_name      = module.cloudsql-dev-env.cloudsql_instance_connection_name

  cloud_sql_instance_password  = module.cloudsql-dev-env.cloudsql_instance_password
  cloud_sql_instance_username  = module.cloudsql-dev-env.cloudsql_instance_username
  cloudsql_service_account_key = module.cloudsql-dev-env.cloudsql_service_account_key

  global_static_ip_name = module.gke-dev-env.gke_static_ip_name

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
# Random service secret for use between image-service and image-proxy
resource "random_string" "service_secret" {
  length           = 16
  special          = false
}

module "dev-image-server" {
  source = "../../modules/core-services/go-image-server"

  project_id     = local.project_id
  region         = local.region
  service_secret = random_string.service_secret.result
}

module "dev-image-proxy-server" {
  source = "../../modules/core-services/go-image-proxy"

  project_id     = local.project_id
  region         = local.region
  service_secret = random_string.service_secret.result
}
# ------------------------------------------------------------------------