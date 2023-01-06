variable "project_id" {
  description = "GCP Project Id"
}

variable "region" {
  description = "GCP deploy region"
}

variable "namespace" {
  type    = string
  default = "nginx"
}

variable "helm_nginx_version" {
  type    = string
  default = "4.4.0"
}

variable "helm_nginx_name" {
  type    = string
  default = "nginx-service"
}

variable "regional_static_ip_address" {
  description = "Regional Static External IP address for LoadBalancer"
}
