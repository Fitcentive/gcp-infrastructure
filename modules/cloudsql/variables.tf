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
  default     = "250"
  description = "Max db connections to CloudSql instance"
}

variable "database_machine_tier" {
  default = "db-f1-micro"
  # default     = "db-n1-standard-1"
  description = "CloudSQL machine instance type. Check https://cloud.google.com/sql/docs/mysql/instance-settings#storage-capacity-2ndgen for more info"
}