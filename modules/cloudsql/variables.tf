variable "keycloak_db_username" {
  description = "Username for keycloak db"
  default = "keycloak"
}

variable "region" {
  description = "GCP deploy region"
}

variable "project_id" {
  description = "GCP Project Id"
}
