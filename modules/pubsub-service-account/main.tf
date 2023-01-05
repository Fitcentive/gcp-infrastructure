resource "google_service_account" "notification-service-service-account" {
  account_id   = "${var.namespace}-service-account"
  display_name = "Service Account for ${var.service_name} to use Google PubSub"
}

resource "google_service_account_key" "notification-service-service-account-key" {
  service_account_id = google_service_account.notification-service-service-account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "notification-service-service-account-iam-member" {
  project = var.project_id
  role    = "roles/pubsub.admin"
  member  = "serviceAccount:${google_service_account.notification-service-service-account.email}"
}

resource "kubernetes_secret" "notification-service-service-account-credentials" {
  metadata {
    name      = "notification-service-service-account-credentials"
    namespace = var.namespace
  }
  data = {
    GOOGLE_APPLICATION_CREDENTIALS = base64decode(google_service_account_key.notification-service-service-account-key.private_key)
  }
}