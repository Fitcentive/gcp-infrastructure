terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

# Create and push custom keycloak docker image with Apple SSO provider to GCR
resource "null_resource" "push_custom_keycloak_docker_image_to_gcr" {
  provisioner "local-exec" {
    command = <<-EOT
      docker build -t ${var.helm_keycloak_name}:latest -t ${var.helm_keycloak_name}:1.0 ${path.module}/resources/
      docker tag ${var.helm_keycloak_name}:1.0 gcr.io/${var.project_id}/${var.helm_keycloak_name}:1.0
      docker push gcr.io/${var.project_id}/${var.helm_keycloak_name}:1.0
    EOT
  }
}

resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = var.namespace
  }
}

module "keycloak-helm-db" {
  source = "../cloudsql-resources"

  cloud_sql_instance_connection_name = var.cloud_sql_instance_connection_name
  cloud_sql_instance_name            = var.cloud_sql_instance_name
  cloudsql_service_account_key       = var.cloudsql_service_account_key
  database_name                      = var.keycloak_db_name
  namespace                          = var.namespace

  depends_on = [
    kubernetes_namespace.keycloak
  ]
}

resource "helm_release" "keycloak" {
  repository = "codecentric"
  chart      = "keycloak"
  version    = var.helm_keycloak_version
  namespace  = var.namespace
  name       = var.helm_keycloak_name

  values = [
    sensitive(templatefile("${path.module}/resources/helm-values/custom_Keycloak.yaml", {
      KEYCLOAK_SERVER_IMAGE             = "gcr.io/${var.project_id}/${var.helm_keycloak_name}"
      KEYCLOAK_CLOUDSQL_INSTANCE_SECRET = module.keycloak-helm-db.cloudsql_instance_credentials_name
      KEYCLOAK_CLOUDSQL_DATABASE_SECRET = module.keycloak-helm-db.cloudsql_database_credentials_name
      GCP_CLOUD_SQL_INSTANCE            = var.cloud_sql_instance_connection_name
    }))
  ]

  depends_on = [
    kubernetes_namespace.keycloak,
    null_resource.push_custom_keycloak_docker_image_to_gcr,
    module.keycloak-helm-db,
  ]
}

# Note - YAML not in separate file so that ssl policy can be interpolated in TF
# Note - not using this as nginx handles ssl redirect itself
#resource "kubectl_manifest" "keycloak-ingress-gcp-frontend-config" {
#  yaml_body = <<YAML
#apiVersion: networking.gke.io/v1beta1
#kind: FrontendConfig
#metadata:
#  name: ${var.namespace}-ingress-frontend-config
#  namespace: ${var.namespace}
#spec:
#  sslPolicy: ${var.ssl_policy_name}
#  redirectToHttps:
#    enabled: true
#    responseCodeName: MOVED_PERMANENTLY_DEFAULT
#YAML
#}

resource "kubernetes_ingress_v1" "keycloak-basic-login-ingress" {
  metadata {
    name = "${var.namespace}-basic-login-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                = "nginx"
      "cert-manager.io/cluster-issuer"             = "letsencrypt-cluster-issuer"
      "nginx.ingress.kubernetes.io/ssl-redirect"   = true
      "nginx.ingress.kubernetes.io/rewrite-target" = "/auth/realms/NativeAuth/protocol/openid-connect/token"
    }
    namespace = var.namespace
  }

  spec {
    rule {
      host = var.keycloak_server_host
      http {
        path {
          path      = "/api/auth/login/basic"
          path_type = "Exact"
          backend {
            service {
              name = "${var.namespace}-service-http"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [var.keycloak_server_host]
      secret_name = "keycloak-tls-certificate"
    }
  }
}

resource "kubernetes_ingress_v1" "keycloak-ingress" {
  metadata {
    name = "${var.namespace}-ingress"
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "cert-manager.io/cluster-issuer"           = "letsencrypt-cluster-issuer"
      "nginx.ingress.kubernetes.io/ssl-redirect" = true
    }
    namespace = var.namespace
  }

  spec {
    rule {
      host = var.keycloak_server_host
      http {
        path {
          path      = "/auth"
          path_type = "Prefix"
          backend {
            service {
              name = "${var.namespace}-service-http"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = [var.keycloak_server_host]
      secret_name = "keycloak-tls-certificate"
    }
  }
}

# Avoiding this in favour of using nginx + letsEncrypt instead
#resource "kubectl_manifest" "keycloak-ingress-managed-certificate" {
#  yaml_body = <<YAML
#apiVersion: networking.gke.io/v1
#kind: ManagedCertificate
#metadata:
#  name: ${var.namespace}-ingress-managed-certificate
#  namespace: ${var.namespace}
#spec:
#  domains:
#    - auth.fitcentive.xyz
#YAML
#}