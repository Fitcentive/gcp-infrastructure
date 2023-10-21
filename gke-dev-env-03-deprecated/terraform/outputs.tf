output "region" {
  value       = local.region
  description = "GCloud Region"
}

output "project_id" {
  value       = local.project_id
  description = "GCloud Project ID"
}

output "cloudsql_database_instance_connection" {
  value       = module.cloudsql-dev-env.cloudsql_instance_connection_name
  description = "GCP Cloud SQL DB instance connection name"
}

