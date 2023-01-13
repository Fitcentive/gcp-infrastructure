locals {
  project_id        = "fitcentive-dev"
  region            = "northamerica-northeast2"
  firebase_location = "northamerica-northeast1"
  zone              = "northamerica-northeast2-a"

  gcp_service_list = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "sqladmin.googleapis.com",
    "iam.googleapis.com",
    "firebase.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}