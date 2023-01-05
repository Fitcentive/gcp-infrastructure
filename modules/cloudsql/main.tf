# Google Cloud SQL instance
# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "gke-dev-env-cloud-sql-instance" {
  name             = "gke-dev-env-cloud-sql-instance"
  region           = var.region
  database_version = "POSTGRES_14"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection = "true"
}

resource "random_password" "pwd" {
  length  = 16
  special = false
}

resource "google_sql_user" "keycloak" {
  name     = var.keycloak_db_username
  instance = google_sql_database_instance.gke-dev-env-cloud-sql-instance.name
  password = random_password.pwd.result
}

resource "google_service_account" "cloudsql-service-account" {
  account_id   = "cloudsql-service-account"
  display_name = "Service Account to run CloudSql Proxy as sidecar container(s)"
}

resource "google_service_account_key" "cloudsql-service-account-key" {
  service_account_id = google_service_account.cloudsql-service-account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "cloudsql-service-account-iam-member" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudsql-service-account.email}"
}
