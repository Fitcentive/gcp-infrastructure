output "region" {
  value       = local.region
  description = "GCloud Region"
}

output "project_id" {
  value       = local.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = module.gke-dev-env.kubernetes_cluster_name
  description = "GKE Cluster Name"
}

output "kubernetes_client_cert" {
  value       = module.gke-dev-env.kubernetes_client_cert
  description = "GKE Cluster Cert"
}

output "kubernetes_client_key" {
  value       = module.gke-dev-env.kubernetes_client_key
  description = "GKE Cluster Client key"
  sensitive   = true
}

output "kubernetes_cluster_ca_certificate" {
  value       = module.gke-dev-env.kubernetes_cluster_ca_certificate
  description = "GKE Cluster CA Certificate"
  sensitive   = true
}

output "kubernetes_cluster_host" {
  value       = module.gke-dev-env.kubernetes_cluster_host
  description = "GKE Cluster Host"
}

output "cloudsql_database_instance_connection" {
  value       = module.cloudsql-dev-env.cloudsql_instance_connection_name
  description = "GCP Cloud SQL DB instance connection name"
}

output "gke_static_ip_name" {
  value       = module.gke-dev-env.gke_static_ip_name
  description = "GKE Static IP name"
}

output "gke_static_ip_address" {
  value       = module.gke-dev-env.gke_static_ip_address
  description = "GKE Static IP address"
}

output "firebase_firestore_database_url" {
  value       = module.dev-firebase-project.firestore_database_url
  description = "Firebase firestore database URL"
}