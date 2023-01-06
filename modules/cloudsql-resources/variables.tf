variable "cloud_sql_instance_name" {
  description = "GCP Cloud SQL instance to create databases on"
}

variable "cloud_sql_instance_connection_name" {
  description = "GCP Cloud SQL instance connection name"
}

variable "cloudsql_service_account_key" {
  description = "Base64 version of service account key file for CloudSql"
}

variable "database_name" {
  description = "Name of CloudSql database to create"
}

variable "namespace" {
  description = "Namespace in which to create resources"
}