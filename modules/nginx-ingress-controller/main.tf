resource "kubernetes_namespace" "nginx" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "nginx" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.helm_nginx_version
  namespace  = var.namespace
  name       = var.helm_nginx_name

  values = [
    sensitive(templatefile("${path.module}/resources/custom_NginxIngressController.yaml", {
      STATIC_LOAD_BALANCER_IP_ADDRESS = var.regional_static_ip_address
    }))
  ]

  depends_on = [
    kubernetes_namespace.nginx
  ]
}