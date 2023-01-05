resource "kubernetes_namespace" "image-service" {
  metadata {
    name = var.namespace
  }
}

resource "null_resource" "push-custom-image-service-image-to-gcr" {
  provisioner "local-exec" {
    command = <<-EOT
      docker build -t ${var.namespace}:latest -t ${var.namespace}:1.0 ${path.module}/resources/
      docker tag ${var.namespace}:1.0 gcr.io/place-2-meet-dev/${var.namespace}:1.0
      docker push gcr.io/${var.project_id}/${var.namespace}:1.0
    EOT
  }
}

# Note - requires a file `status.png` in the bucket root to satisfy k8s health checks
resource "google_storage_bucket" "image-service-upload-images-storage-bucket" {
  name          = var.image_service_bucket_name
  force_destroy = false
  location      = var.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

resource "google_service_account" "go-image-service-service-account" {
  account_id   = "image-svc-service-account"
  display_name = "Service Account for go-image-service to store data on GCS"
}

resource "google_service_account_key" "go-image-service-service-account-key" {
  service_account_id = google_service_account.go-image-service-service-account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "go-image-service-service-account-iam-member" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.go-image-service-service-account.email}"
}

resource "kubernetes_secret" "image-service-service-account-credentials" {
  metadata {
    name      = "image-service-service-account-credentials"
    namespace = var.namespace
  }
  data = {
    GOOGLE_APPLICATION_CREDENTIALS = base64decode(google_service_account_key.go-image-service-service-account-key.private_key)
  }

  depends_on = [
    kubernetes_namespace.image-service
  ]
}

resource "kubernetes_deployment_v1" "image-service-deployment" {
  metadata {
    name      = var.namespace
    namespace = var.namespace
    labels = {
      app = var.namespace
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.namespace
      }
    }

    template {
      metadata {
        labels = {
          app = var.namespace
        }
      }
      spec {
        container {
          name = var.namespace
          security_context {
            privileged = true
            capabilities {
              add = [
                "SYS_ADMIN"
              ]
            }
          }
          image   = "gcr.io/${var.project_id}/${var.namespace}:1.0"
          command = ["entrypoint.sh"]
          args = [
            "-token",
            var.service_secret,
            "-upload_limit",
            "4950996300",
            "/opt/media"
          ]
          resources {
            requests = {
              memory = "512Mi"
              cpu    = "100m"
            }
            limits = {
              memory = "1024Mi"
              cpu    = "250m"
            }
          }
          port {
            name           = "http-port"
            container_port = 25478
          }
          liveness_probe {
            http_get {
              path = "/files/status.png?token=${var.service_secret}"
              port = "http-port"
            }
            initial_delay_seconds = 60
            period_seconds        = 3
          }
          readiness_probe {
            http_get {
              path = "/files/status.png?token=${var.service_secret}"
              port = "http-port"
            }
            initial_delay_seconds = 60
            period_seconds        = 3
          }
          env {
            name  = "BUCKET"
            value = var.image_service_bucket_name
          }
          env {
            name  = "MOUNT"
            value = "/opt/media"
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.image-service-service-account-credentials.metadata.0.name
            }
          }
        }

        volume {
          name = "cache-volume"
          empty_dir {}
        }
      }
    }
  }

  depends_on = [
    null_resource.push-custom-image-service-image-to-gcr,
    kubernetes_namespace.image-service,
    google_storage_bucket.image-service-upload-images-storage-bucket,
    google_service_account_key.go-image-service-service-account-key
  ]
}


resource "kubernetes_service_v1" "image-service-service" {
  metadata {
    name      = var.namespace
    namespace = var.namespace
  }
  spec {
    selector = {
      app = var.namespace
    }
    port {
      protocol    = "TCP"
      target_port = "http-port"
      port        = var.image_service_port
    }
  }

  depends_on = [
    kubernetes_namespace.image-service
  ]
}