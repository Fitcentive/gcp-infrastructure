module "pubsub-service-account" {
  source = "../../pubsub-service-account"

  project_id   = var.project_id
  namespace    = var.namespace
  service_name = var.service_name
}

module "chat-service-db" {
  source = "../../cloudsql-resources"

  cloud_sql_instance_connection_name = var.cloud_sql_instance_connection_name
  cloud_sql_instance_name            = var.cloud_sql_instance_name
  cloudsql_service_account_key       = var.cloudsql_service_account_key
  database_name                      = var.database_name
  namespace                          = var.namespace
}

resource "kubernetes_secret" "chat-cloudsql-database-url" {
  metadata {
    name      = "${var.service_name}-cloudsql-database-url"
    namespace = var.namespace
  }

  data = {
    DATABASE_URL = "ecto://${module.chat-service-db.cloudsql_instance_username}:${module.chat-service-db.cloudsql_instance_password}@localhost:5432/${module.chat-service-db.cloudsql_database_name}"
  }

}

resource "kubernetes_secret" "native-auth-public-credentials" {
  metadata {
    name      = "${var.service_name}-native-auth-public-credentials"
    namespace = var.namespace
  }

  data = {
    NATIVE_AUTH_KEY_ID     = var.native_auth_key_id
    NATIVE_AUTH_PUBLIC_KEY = var.native_auth_public_key
    NATIVE_AUTH_ISSUER     = "${var.auth_server_url}/auth/realms/NativeAuth"
  }

}

resource "kubernetes_secret" "google-auth-public-credentials" {
  metadata {
    name      = "${var.service_name}-google-auth-public-credentials"
    namespace = var.namespace
  }

  data = {
    GOOGLE_AUTH_KEY_ID     = var.google_auth_key_id
    GOOGLE_AUTH_PUBLIC_KEY = var.google_auth_public_key
    GOOGLE_AUTH_ISSUER     = "${var.auth_server_url}/auth/realms/GoogleAuth"
  }

}

resource "kubernetes_secret" "facebook-auth-public-credentials" {
  metadata {
    name      = "${var.service_name}-facebook-auth-public-credentials"
    namespace = var.namespace
  }

  data = {
    FACEBOOK_AUTH_KEY_ID     = var.facebook_auth_key_id
    FACEBOOK_AUTH_PUBLIC_KEY = var.facebook_auth_public_key
    FACEBOOK_AUTH_ISSUER     = "${var.auth_server_url}/auth/realms/FacebookAuth"
  }

}

resource "kubernetes_secret" "apple-auth-public-credentials" {
  metadata {
    name      = "${var.service_name}-apple-auth-public-credentials"
    namespace = var.namespace
  }

  data = {
    APPLE_AUTH_KEY_ID     = var.apple_auth_key_id
    APPLE_AUTH_PUBLIC_KEY = var.apple_auth_public_key
    APPLE_AUTH_ISSUER     = "${var.auth_server_url}/auth/realms/AppleAuth"
  }

}