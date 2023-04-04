resource "random_password" "random-password" {
  length  = 16
  special = false
}

resource "google_sql_user" "cloudsql_user" {
  name     = var.namespace
  instance = var.cloud_sql_instance_name
  password = random_password.random-password.result
}

resource "google_sql_database" "service-db" {
  name     = var.database_name
  instance = var.cloud_sql_instance_name

  depends_on = [
    google_sql_user.cloudsql_user
  ]
}

resource "kubernetes_secret" "cloudsql-instance-credentials" {
  metadata {
    name      = "${var.namespace}-service-cloudsql-instance-credentials"
    namespace = var.namespace
  }
  data = {
    "credentials.json" = base64decode(var.cloudsql_service_account_key)
  }

}

resource "kubernetes_secret" "cloudsql-database-credentials" {
  metadata {
    name      = "${var.namespace}-service-cloudsql-database-credentials"
    namespace = var.namespace
  }

  data = {
    DB_DATABASE = google_sql_database.service-db.name
    DB_USER     = google_sql_user.cloudsql_user.name
    DB_PASSWORD = google_sql_user.cloudsql_user.password
  }

}