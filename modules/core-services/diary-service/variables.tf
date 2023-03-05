variable "namespace" {
  type    = string
  default = "diary"
}

variable "service_name" {
  type    = string
  default = "diary-service"
}

variable "database_name" {
  type    = string
  default = "diary-service-db"
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

variable "fatsecret_client_id" {
  description = "Client ID for Fatsecret API"
}

variable "fatsecret_client_secret" {
  description = "Client Secret for Fatsecret API"
}

variable "fatsecret_api_host" {
  description = "API host for Fatsecret API"
  default     = "https://platform.fatsecret.com/rest/server.api"
}

variable "fatsecret_auth_host" {
  description = "Auth host for Fatsecret API"
  default     = "https://oauth.fatsecret.com/connect/token"
}