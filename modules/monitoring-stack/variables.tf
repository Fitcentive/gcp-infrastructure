variable pwd_special_char_subset {
  type        = string
  description = "Kubernetes Namespaces between which secrets are shared"
  default     = "~%?^,.;*()-_=+"
}

variable "kube_monitoring_namespace" {
  type        = string
  default     = "monitoring"
  description = "Kubernetes Namespace for Prometheus Stack"
}

variable "helm_kubepromstack_releasename" {
  type    = string
  default = "kubepromstack"
  description = "Release name"
}

variable "helm_kubepromstack_version" {
  description = "kube-prometheus-stack helm release version. Checked by helm search repo --regexp 'kube-prometheus-stack'"
  type        = string
  default     = "39.9.0"
}