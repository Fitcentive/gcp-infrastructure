resource "google_service_account" "pubsub-service-account" {
  account_id   = "${var.namespace}-service-account"
  display_name = "Service Account for ${var.service_name} to use Google PubSub"
}

resource "google_service_account_key" "pubsub-service-account-key" {
  service_account_id = google_service_account.pubsub-service-account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "pubsub-service-account-iam-member" {
  project = var.project_id
  role    = "roles/pubsub.admin"
  member  = "serviceAccount:${google_service_account.pubsub-service-account.email}"
}

resource "kubernetes_secret" "pubsub-service-account-credentials" {
  metadata {
    name      = "${var.service_name}-service-account-credentials"
    namespace = var.namespace
  }
  data = {
    GOOGLE_APPLICATION_CREDENTIALS = base64decode(google_service_account_key.pubsub-service-account-key.private_key)
  }
}