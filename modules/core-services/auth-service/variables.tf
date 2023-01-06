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

variable "global_static_ip_name" {
  description = "Global Static External IP name"
}

variable "ssl_policy_name" {
  description = "GKE SSL policy name"
}