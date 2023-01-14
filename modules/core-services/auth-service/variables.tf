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