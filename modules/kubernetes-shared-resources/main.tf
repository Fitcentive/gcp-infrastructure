terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

# Random service secret to be used between services in the GKE cluster
resource "random_string" "internal-service-secret" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "internal-service-secret" {
  for_each = toset(var.service_namespaces)

  metadata {
    name      = "internal-service-secret"
    namespace = each.key
  }
  data = {
    INTERNAL_SERVICE_SECRET = random_string.internal-service-secret.result
  }
}

resource "kubernetes_secret" "image-service-secret" {
  for_each = toset(var.service_namespaces)

  metadata {
    name      = "image-service-secret"
    namespace = each.key
  }
  data = {
    IMAGE_SERVICE_TOKEN = var.image_service_token
  }
}