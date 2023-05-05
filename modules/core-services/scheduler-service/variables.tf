variable "namespace" {
  type    = string
  default = "scheduler"
}

variable "database_name" {
  type    = string
  default = "scheduler-service-db"
}

variable "service_name" {
  type    = string
  default = "scheduler-service"
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