variable "namespace" {
  type    = string
  default = "public-gateway"
}

variable "service_name" {
  type    = string
  default = "public-gateway-service"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "ad_unit_id_android" {
  description = "Google AdMob Android Ad Unit ID. Available via AdMob UI"
}

variable "ad_unit_id_ios" {
  description = "Google AdMob iOS Ad Unit ID. Available via AdMob UI"
}