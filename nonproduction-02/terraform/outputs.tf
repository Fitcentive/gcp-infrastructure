output "region" {
  value       = local.region
  description = "GCloud Region"
}

output "project_id" {
  value       = local.project_id
  description = "GCloud Project ID"
}

output "tf_remote_state_bucket_dev" {
  value       = google_storage_bucket.terraform-dev-remote-state-bucket.name
  description = "Terraform remote state storage bucket for DEV environment"
}

# To view output, terraform output -raw tf_service_account_private_key
output "tf_service_account_private_key" {
  value       = module.dev-terraform-service-account.service_account_key
  description = "Base64 version of terraform service account private key"
  sensitive   = true
}

output "firebase_firestore_database_url" {
  value       = module.dev-firebase-project.firestore_database_url
  description = "Firebase firestore database URL"
}

output "gke_dev_kubernetes_cluster_name" {
  value       = module.gke-dev-env.kubernetes_cluster_name
  description = "GKE Cluster Name"
}

output "gke_dev_kubernetes_client_cert" {
  value       = module.gke-dev-env.kubernetes_client_cert
  description = "GKE Cluster Cert"
}

output "gke_dev_kubernetes_client_key" {
  value       = module.gke-dev-env.kubernetes_client_key
  description = "GKE Cluster Client key"
  sensitive   = true
}

output "gke_dev_kubernetes_cluster_ca_certificate" {
  value       = module.gke-dev-env.kubernetes_cluster_ca_certificate
  description = "GKE Cluster CA Certificate"
  sensitive   = true
}

output "gke_dev_kubernetes_cluster_host" {
  value       = module.gke-dev-env.kubernetes_cluster_host
  description = "GKE Cluster Host"
}

output "gke_dev_gke_regional_static_ip_name" {
  value       = module.gke-dev-env.gke_regional_static_ip_name
  description = "GKE Regional Static IP name"
}

output "gke_dev_gke_regional_static_ip_address" {
  value       = module.gke-dev-env.gke_regional_static_ip_address
  description = "GKE Regional Static IP address"
}

output "gke_dev_gke_ssl_policy_name" {
  value       = module.gke-dev-env.gke_ssl_policy_name
  description = "GKE SSL Policy name"
}