resource "random_password" "grafana-admin-pwd" {
  length  = 30
  special = false
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.kube_monitoring_namespace
  }
}

# https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
resource "helm_release" "prometheus-stack" {
  name       = var.helm_kubepromstack_releasename
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.helm_kubepromstack_version
  namespace  = var.kube_monitoring_namespace

  values = [
    sensitive(templatefile("${path.module}/helm-values/custom_kube-prometheus-stack.yaml", {
      HELM_KUBEPROMSTACK_RELEASE_NAME = var.helm_kubepromstack_releasename
    })),

    sensitive(templatefile("${path.module}/helm-values/custom_Grafana.yaml", {
      HELM_KUBEPROMSTACK_RELEASE_NAME = var.helm_kubepromstack_releasename
      KUBEPROMSTACK_NAMESPACE         = var.kube_monitoring_namespace
      THANOS_K8S_NAMESPACE            = var.kube_monitoring_namespace
    })),
  ]

  set {
    name  = "grafana.adminPassword"
    value = random_password.grafana-admin-pwd.result
  }

  timeout    = 900
  depends_on = [kubernetes_namespace.monitoring]
}