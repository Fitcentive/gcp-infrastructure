variable "namespace" {
  type    = string
  default = "notification"
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
