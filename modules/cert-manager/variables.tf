variable "release_name" {
  description = "Helm release name"
  default     = "cert-manager"
}

variable "chart_name" {
  description = "Helm chart name to provision"
  default     = "cert-manager"
}

variable "chart_repository" {
  description = "Helm repository for the chart"
  default     = "https://charts.jetstack.io"
}

variable "chart_version" {
  description = "Version of Chart to install. Set to empty to install the latest version"
  default     = "v1.10.1"
}

variable "chart_namespace" {
  description = "Namespace to install the chart into"
  default     = "cert-manager"
}

variable "chart_timeout" {
  description = "Timeout to wait for the Chart to be deployed."
  default     = 300
}

variable "max_history" {
  description = "Max History for Helm"
  default     = 20
}

#######################
# Chart Values
#######################

variable "psp_enable" {
  description = "Create PodSecurityPolicy"
  default     = false
}

variable "psp_apparmor" {
  description = "Use AppArmor with PSP."
  default     = true
}

variable "install_crds" {
  description = "Install CRDs with chart"
  default     = true
}

variable "prometheus_enabled" {
  description = "Enable Prometheus metrics"
  default     = true
}
