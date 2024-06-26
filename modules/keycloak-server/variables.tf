variable "namespace" {
  type    = string
  default = "keycloak"
}

variable "keycloak_db_name" {
  type    = string
  default = "keycloak-helm-db"
}

variable "helm_keycloak_version" {
  type    = string
  default = "18.1.1"
}

variable "helm_keycloak_name" {
  type    = string
  default = "keycloak-service"
}

variable "db_username" {
  type    = string
  default = "user"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "region" {
  description = "GCP deploy region"
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

variable "global_static_ip_name" {
  description = "Global Static External IP name"
}

variable "ssl_policy_name" {
  description = "GKE SSL policy name"
}

variable "keycloak_server_host" {
  description = "Host url of keycloak server"
}