variable "namespace" {
  type    = string
  default = "auth"
}

variable "service_name" {
  type    = string
  default = "auth-service"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "keycloak_admin_client_password" {
  description = "Keycloak admin client password"
}

variable "keycloak_admin_client_secret" {
  description = "Keycloak admin client secret"
}

variable "keycloak_admin_client_id" {
  default     = "admin-cli"
  description = "Keycloak admin client ID"
}

variable "keycloak_admin_client_username" {
  default     = "admin"
  description = "Keycloak admin client username"
}