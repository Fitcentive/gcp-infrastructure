resource "kubernetes_namespace" "nginx" {
  metadata {
    name = var.namespace
  }
}

# Create and push custom nginx default backend image
resource "null_resource" "push_custom_nginx_ingress_default_backend_image_to_gcr" {
  provisioner "local-exec" {
    command = <<-EOT
      docker build -t ${var.helm_nginx_name}-default-backend:latest -t ${var.helm_nginx_name}-default-backend:1.0 ${path.module}/resources/
      docker tag ${var.helm_nginx_name}-default-backend:1.0 gcr.io/${var.project_id}/${var.helm_nginx_name}-default-backend:1.0
      docker push gcr.io/${var.project_id}/${var.helm_nginx_name}-default-backend:1.0
    EOT
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
      STATIC_LOAD_BALANCER_IP_ADDRESS = var.regional_static_ip_address,
      GCP_PROJECT_ID = var.project_id,
      HELM_NAME = var.helm_nginx_name,
    }))
  ]

  depends_on = [
    kubernetes_namespace.nginx,
    null_resource.push_custom_nginx_ingress_default_backend_image_to_gcr
  ]
}