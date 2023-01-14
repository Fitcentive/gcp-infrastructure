locals {
  project_id        = "fitcentive-dev"
  region            = "northamerica-northeast2"
  firebase_location = "northamerica-northeast1"
  zone              = "northamerica-northeast2-a"

  secondary_namespaces = [
    "image-service",
    "image-proxy"
  ]

  service_namespaces = [
    "chat",
    "auth",
    "notification",
    "user",
    "social",
    "public-gateway",
    "discover",
  ]

  neo4j_db_name  = "FitcentiveGraphDb"
  neo4j_password = "Ik6dX_r5t1UQWe6mU89gWUVUiX13cqHsztdEL8mEv5M"
  neo4j_uri      = "neo4j+s://c705512b.databases.neo4j.io"
  neo4j_username = "neo4j"

  # Note - the following value is fetched from https://console.firebase.google.com/u/1/project/fitcentive-dev/settings/serviceaccounts/adminsdk
  # This value is created when parent `nonproduction` project's `module.dev-firebase-project` is executed successfully
  # Refer to the README.adoc for more info on how to set this value appropriately
  firebase_admin_service_account = "firebase-adminsdk-7jk1g"

}