variable "namespace" {
  type    = string
  default = "chat"
}

variable "database_name" {
  type    = string
  default = "chat-db"
}

variable "service_name" {
  type    = string
  default = "chat-service"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "cloud_sql_instance_name" {
  description = "GCP Cloud SQL instance to create databases on"
}

variable "cloud_sql_instance_connection_name" {
  description = "GCP Cloud SQL instance connection name"
}

variable "cloudsql_service_account_key" {
  description = "Base64 version of service account key file for CloudSql"
}

variable "auth_server_url" {
  description = "Auth server URL"
}

variable "native_auth_key_id" {
  description = "Public Key ID for Keycloak Native auth realm"
}

variable "native_auth_public_key" {
  description = "Public Key for Keycloak Native auth realm"
}

variable "google_auth_key_id" {
  description = "Public Key ID for Keycloak Google auth realm"
}

variable "google_auth_public_key" {
  description = "Public Key for Keycloak Google auth realm"
}

variable "apple_auth_key_id" {
  description = "Public Key ID for Keycloak Apple auth realm"
}

variable "apple_auth_public_key" {
  description = "Public Key for Keycloak Apple auth realm"
}

variable "facebook_auth_key_id" {
  description = "Public Key ID for Facebook Apple auth realm"
}

variable "facebook_auth_public_key" {
  description = "Public Key for Facebook Apple auth realm"
}

