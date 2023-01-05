variable "service_namespaces" {
  type        = list(string)
  description = "Kubernetes Namespaces between which secrets are shared"
}

variable "certificate_namespaces" {
  type        = list(string)
  description = "Kubernetes Namespaces for which gooogle-managed certificates are generated"
}