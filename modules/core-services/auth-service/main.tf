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
    KEYCLOAK_ADMIN_CLIENT_ID           = "admin-cli"
    KEYCLOAK_ADMIN_CLIENT_SECRET       = random_password.keycloak-client-secret.result
    KEYCLOAK_ADMIN_USERNAME            = "admin"
    KEYCLOAK_ADMIN_PASSWORD            = var.keycloak_admin_client_password
  }
}