terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "auth-ingress-gcp-frontend-config" {
  yaml_body = <<YAML
apiVersion: networking.gke.io/v1beta1
kind: FrontendConfig
metadata:
  name: ${var.namespace}-ingress-frontend-config
  namespace: ${var.namespace}
spec:
  sslPolicy: ${var.ssl_policy_name}
  redirectToHttps:
    enabled: true
    responseCodeName: MOVED_PERMANENTLY_DEFAULT
YAML
}

resource "kubernetes_ingress_v1" "auth-ingress" {
  metadata {
    name = "${var.namespace}-ingress"
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = var.global_static_ip_name
      "networking.gke.io/v1beta1.FrontendConfig"    = "${var.namespace}-ingress-frontend-config"
      "networking.gke.io/managed-certificates"      = "${var.namespace}-ingress-managed-certificate"
      "kubernetes.io/ingress.class"                 = "gce"
    }
    namespace = var.namespace
  }

  spec {
    rule {
      http {
        path {
          path      = "/api/auth"
          path_type = "Prefix"
          backend {
            service {
              name = "${var.namespace}-service"
              port {
                number = 9000
              }
            }
          }
        }
        path {
          path = "/api/internal/auth"
          path_type = "Prefix"
          backend {
            service {
              name = "${var.namespace}-service"
              port {
                number = 9000
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubectl_manifest.auth-ingress-gcp-frontend-config
  ]
}

resource "kubectl_manifest" "auth-ingress-managed-certificate" {
  yaml_body = <<YAML
apiVersion: networking.gke.io/v1
kind: ManagedCertificate
metadata:
  name: ${var.namespace}-ingress-managed-certificate
  namespace: ${var.namespace}
spec:
  domains:
    - auth.fitcentive.xyz
YAML
}