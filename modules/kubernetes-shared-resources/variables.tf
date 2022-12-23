variable kubernetes_namespaces {
  type        = list(string)
  description = "Kubernetes Namespaces between which secrets are shared"
}