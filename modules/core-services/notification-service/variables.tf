variable "namespace" {
  type    = string
  default = "notification"
}

variable "database_name" {
  type    = string
  default = "notification-service-db"
}

variable "service_name" {
  type    = string
  default = "notification-service"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "firebase_database_url" {
  description = "Firebase Database URL"
}

variable "firebase_admin_service_account" {
  description = "Firebase Admin Service Account name"
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

variable "smtp_user" {
  description = "SMTP user credential"
}

variable "smtp_password" {
  description = "SMTP user password"
}

variable "smtp_host" {
  description = "SMTP server host"
}

variable "smtp_port" {
  description = "SMTP server port"
}