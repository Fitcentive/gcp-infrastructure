variable "namespace" {
  type    = string
  default = "mailhog"
}

variable "helm_mailhog_name" {
  type    = string
  default = "mailhog-service"
}

variable "project_id" {
  description = "GCP Project Id"
}

variable "region" {
  description = "GCP deploy region"
}