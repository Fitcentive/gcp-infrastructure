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
    name = "keycloak-cloudsql-instance-credentials"
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
    name = "keycloak-cloudsql-database-credentials"
    namespace = var.namespace
  }

  data = {
    DB_DATABASE = google_sql_database.keycloak-helm-db.name
    DB_USER = var.cloud_sql_instance_username
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
      KEYCLOAK_SERVER_IMAGE              = "gcr.io/${var.project_id}/${var.helm_keycloak_name}"
      KEYCLOAK_CLOUDSQL_INSTANCE_SECRET  = kubernetes_secret.keycloak-cloudsql-instance-credentials.metadata.0.name
      KEYCLOAK_CLOUDSQL_DATABASE_SECRET  = kubernetes_secret.keycloak-cloudsql-database-credentials.metadata.0.name
      GCP_CLOUD_SQL_INSTANCE             = var.cloud_sql_instance_connection_name
    }))
  ]

  depends_on = [
    kubernetes_namespace.keycloak,
    kubernetes_secret.keycloak-cloudsql-instance-credentials,
    kubernetes_secret.keycloak-cloudsql-database-credentials,
    null_resource.push_custom_keycloak_docker_image_to_gcr
  ]
}