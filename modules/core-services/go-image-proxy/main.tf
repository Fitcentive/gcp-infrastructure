resource "kubernetes_namespace" "image-proxy" {
  metadata {
    name = var.namespace
  }
}

resource "null_resource" "push-custom-image-proxy-image-to-gcr" {
  provisioner "local-exec" {
    command = <<-EOT
      docker pull ${var.image_service_raw_image}:${var.image_service_raw_image_version}
      docker tag ${var.image_service_raw_image}:${var.image_service_raw_image_version} gcr.io/place-2-meet-dev/${var.namespace}:1.0
      docker push gcr.io/${var.project_id}/${var.namespace}:1.0
    EOT
  }
}

resource "kubernetes_deployment_v1" "image-proxy-deployment" {
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
          name  = var.namespace
          image = "gcr.io/${var.project_id}/${var.namespace}:1.0"
          args = [
            "-addr",
            "0.0.0.0:8080",
            "-cache",
            "/tmp/${var.namespace}",
            "-baseURL",
            "http://${var.image_service_namespace}.${var.image_service_namespace}:${var.image_service_port}/files",
            "-whitelist",
            "${var.image_service_namespace}.${var.image_service_namespace}:${var.image_service_port}"
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
          volume_mount {
            mount_path = "/tmp/${var.namespace}"
            name       = "cache-volume"
          }
          port {
            name           = "http-port"
            container_port = 8080
          }
          liveness_probe {
            http_get {
              path = "/2x/files/status.png?token=${var.service_secret}"
              port = "http-port"
            }
            initial_delay_seconds = 60
            period_seconds        = 3
          }
          readiness_probe {
            http_get {
              path = "/2x/files/status.png?token=${var.service_secret}"
              port = "http-port"
            }
            initial_delay_seconds = 60
            period_seconds        = 3
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
    null_resource.push-custom-image-proxy-image-to-gcr,
    kubernetes_namespace.image-proxy
  ]
}

resource "kubernetes_service_v1" "image-proxy-service" {
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
      port        = var.image_proxy_port
    }
  }

  depends_on = [
    kubernetes_namespace.image-proxy
  ]
}
