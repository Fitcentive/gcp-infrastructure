output "cloudsql_instance_password" {
  value       = google_sql_user.cloudsql_user.password
  description = "Cloud SQL instance password"
  sensitive   = true
}

output "cloudsql_instance_username" {
  value       = google_sql_user.cloudsql_user.name
  description = "Cloud SQL instance username"
}

output "cloudsql_database_name" {
  value       = google_sql_database.service-db.name
  description = "Cloud SQL database name"
}

output "cloudsql_instance_credentials_name" {
  value       = kubernetes_secret.cloudsql-instance-credentials.metadata.0.name
  description = "Cloud SQL instance credentials name"
}

output "cloudsql_database_credentials_name" {
  value       = kubernetes_secret.cloudsql-database-credentials.metadata.0.name
  description = "Cloud SQL database credentials name"
}