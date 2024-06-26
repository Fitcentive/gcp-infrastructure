output "cloudsql_instance_connection_name" {
  value       = google_sql_database_instance.gke-dev-env-cloud-sql-instance.connection_name
  description = "Cloud SQL instance connection name"
}

output "cloudsql_instance_name" {
  value       = google_sql_database_instance.gke-dev-env-cloud-sql-instance.name
  description = "Cloud SQL instance name"
}

output "cloudsql_service_account_key" {
  value       = google_service_account_key.cloudsql-service-account-key.private_key
  description = "Cloud SQL Service account key"
  sensitive   = true
}
