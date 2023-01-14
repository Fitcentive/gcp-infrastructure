variable "namespace" {
  type    = string
  default = "discover"
}

variable "service_name" {
  type    = string
  default = "discover-service"
}

variable "database_name" {
  type    = string
  default = "discover-service-db"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "neo4j_uri" {
  description = "Neo4j Database URI"
}

variable "neo4j_username" {
  description = "Neo4j Database username"
}

variable "neo4j_password" {
  description = "Neo4j Database password"
}

variable "neo4j_db_name" {
  description = "Neo4j Database name"
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