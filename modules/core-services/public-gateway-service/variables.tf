variable "namespace" {
  type    = string
  default = "public-gateway"
}

variable "service_name" {
  type    = string
  default = "public-gateway-service"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "ad_unit_id_android" {
  description = "Google AdMob Android Ad Unit ID. Available via AdMob UI"
}

variable "ad_unit_id_ios" {
  description = "Google AdMob iOS Ad Unit ID. Available via AdMob UI"
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

variable "database_name" {
  type    = string
  default = "public-gateway-service-db"
}
