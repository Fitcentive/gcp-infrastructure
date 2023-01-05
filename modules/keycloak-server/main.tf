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
      docker tag ${var.helm_keycloak_name}:1.0 gcr.io/place-2-meet-dev/${var.helm_keycloak_name}:1.0
      docker push gcr.io/${var.project_id}/${var.helm_keycloak_name}:1.0
    EOT
  }
}


resource "google_sql_database" "keycloak-helm-db" {
  name     = "keycloak-helm-db"
  instance = var.cloud_sql_instance_name
}

resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "keycloak-cloudsql-instance-credentials" {
  metadata {
    name      = "keycloak-cloudsql-instance-credentials"
    namespace = var.namespace
  }
  data = {
    "credentials.json" = base64decode(var.cloudsql_service_account_key)
  }

  depends_on = [
    kubernetes_namespace.keycloak
  ]
}

resource "kubernetes_secret" "keycloak-cloudsql-database-credentials" {
  metadata {
    name      = "keycloak-cloudsql-database-credentials"
    namespace = var.namespace
  }

  data = {
    DB_DATABASE = google_sql_database.keycloak-helm-db.name
    DB_USER     = var.cloud_sql_instance_username
    DB_PASSWORD = var.cloud_sql_instance_password
  }

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
      KEYCLOAK_CLOUDSQL_INSTANCE_SECRET = kubernetes_secret.keycloak-cloudsql-instance-credentials.metadata.0.name
      KEYCLOAK_CLOUDSQL_DATABASE_SECRET = kubernetes_secret.keycloak-cloudsql-database-credentials.metadata.0.name
      GCP_CLOUD_SQL_INSTANCE            = var.cloud_sql_instance_connection_name
    }))
  ]

  depends_on = [
    kubernetes_namespace.keycloak,
    kubernetes_secret.keycloak-cloudsql-instance-credentials,
    kubernetes_secret.keycloak-cloudsql-database-credentials,
    null_resource.push_custom_keycloak_docker_image_to_gcr
  ]
}

# Note - YAML not in separate file so that ssl policy can be interpolated in TF
resource "kubectl_manifest" "keycloak-ingress-gcp-frontend-config" {
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

resource "kubernetes_ingress_v1" "keycloak-ingress" {
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
  }

  depends_on = [
    kubectl_manifest.keycloak-ingress-gcp-frontend-config
  ]
}

resource "kubectl_manifest" "keycloak-ingress-managed-certificate" {
  yaml_body = <<YAML
apiVersion: networking.gke.io/v1
kind: ManagedCertificate
metadata:
  name: ${var.namespace}-ingress-managed-certificate
  namespace: ${var.namespace}
spec:
  domains:
    - fitcentive.xyz
YAML
}