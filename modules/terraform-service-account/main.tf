resource "google_service_account" "terraform-service-account" {
  account_id   = "terraform-service-account"
  display_name = "Terraform Service Account"
  description  = "Service Account for Terraform to provision resources on GCP. This will be the assumed identity for all terraform applies"
}

resource "google_service_account_key" "terraform-service-account-key" {
  service_account_id = google_service_account.terraform-service-account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "terraform-service-account-organization-admin" {
  project = var.project_id
  role    = "roles/resourcemanager.organizationAdmin"
  member  = "serviceAccount:${google_service_account.terraform-service-account.email}"
}

resource "google_project_iam_member" "terraform-service-account-storage-admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.terraform-service-account.email}"
}

resource "google_project_iam_member" "terraform-service-account-compute-admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.terraform-service-account.email}"
}

resource "google_project_iam_member" "terraform-service-account-container-admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.terraform-service-account.email}"
}

resource "google_project_iam_member" "terraform-service-account-firebase-admin" {
  project = var.project_id
  role    = "roles/firebase.admin"
  member  = "serviceAccount:${google_service_account.terraform-service-account.email}"
}

resource "google_project_iam_member" "terraform-service-account-cloudfunctions-admin" {
  project = var.project_id
  role    = "roles/cloudfunctions.admin"
  member  = "serviceAccount:${google_service_account.terraform-service-account.email}"
}

resource "google_project_iam_member" "terraform-service-account-editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.terraform-service-account.email}"
}
