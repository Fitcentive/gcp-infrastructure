resource "kubernetes_namespace" "mailhog" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "mailhog" {
  repository = "codecentric"
  chart      = "mailhog"
  namespace  = var.namespace
  name       = var.helm_mailhog_name

  depends_on = [
    kubernetes_namespace.mailhog
  ]
}