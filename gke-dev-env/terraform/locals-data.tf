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

  # These are those namespaces that require a google-managed certificate to be generated
  certificate_namespaces = [
    "auth",
    "public-gateway",
  ]
}