variable "namespace" {
  type    = string
  default = "image-proxy"
}

variable "image_service_raw_image" {
  type    = string
  default = "willnorris/imageproxy"
}

variable "image_service_raw_image_version" {
  type    = string
  default = "v0.8.0"
}

variable "image_service_namespace" {
  type    = string
  default = "image-service"
}

variable "image_service_port" {
  type    = string
  default = "10260"
}

variable "image_proxy_port" {
  type    = string
  default = "10270"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "region" {
  description = "GCP deploy region"
}

variable "service_secret" {
  description = "Service secret for image services"
}