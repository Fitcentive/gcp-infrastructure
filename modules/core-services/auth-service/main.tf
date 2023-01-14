resource "random_password" "keycloak-client-secret" {
  length  = 20
  special = false
}

resource "kubernetes_secret" "keycloak-admin-cli-secrets" {
  metadata {
    name      = "${var.service_name}-keycloak-admin-cli-secrets"
    namespace = var.namespace
  }

  data = {
    KEYCLOAK_ADMIN_CLIENT_ID     = var.keycloak_admin_client_id
    KEYCLOAK_ADMIN_CLIENT_SECRET = var.keycloak_admin_client_secret
    KEYCLOAK_ADMIN_USERNAME      = var.keycloak_admin_client_username
    KEYCLOAK_ADMIN_PASSWORD      = var.keycloak_admin_client_password
  }
}