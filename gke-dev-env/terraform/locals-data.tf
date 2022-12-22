locals {
  project_id  = "place-2-meet-dev"
  region      = "northamerica-northeast2"
  zone        = "northamerica-northeast2-a"

  secondary_namespaces = [
    "image-service",
    "image-proxy",
  ]

  functional_namespaces = [
    "auth",
    "public-gateway",
  ]
}