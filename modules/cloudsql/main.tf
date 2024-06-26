resource "random_string" "cloud-sql-root-password" {
  length  = 20
  special = true
}

# Google Cloud SQL instance
# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "gke-dev-env-cloud-sql-instance" {
  name             = "gke-dev-env-cloud-sql-instance"
  region           = var.region
  database_version = "POSTGRES_14"

  # Note on root password - tf deletes this user on instance creation, so it is useless. Need to create users explicitly
  root_password = random_string.cloud-sql-root-password.result

  settings {
    database_flags {
      name  = "max_connections"
      value = var.cloud_sql_max_connections
    }
    tier = var.database_machine_tier
  }

  # Set this to false if needed to destroy resource
  deletion_protection = "false"
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
