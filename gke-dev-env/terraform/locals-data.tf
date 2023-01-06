locals {
  project_id        = "place-2-meet-dev"
  region            = "northamerica-northeast2"
  firebase_location = "northamerica-northeast1"
  zone              = "northamerica-northeast2-a"

  secondary_namespaces = [
    "image-service",
    "image-proxy"
  ]

  service_namespaces = [
    "auth",
    "notification",
    "user",
    "social",
    "public-gateway",
  ]

}