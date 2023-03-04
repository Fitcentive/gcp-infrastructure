variable "keycloak_db_username" {
  description = "Username for keycloak db"
  default     = "keycloak"
}

variable "region" {
  description = "GCP deploy region"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "cloud_sql_max_connections" {
  default     = "100"
  description = "Max db connections to CloudSql instance"
}