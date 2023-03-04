variable "service_namespaces" {
  type        = list(string)
  description = "Kubernetes Namespaces between which secrets are shared"
}

variable "image_service_token" {
  type        = string
  description = "Image service opaque token"
}