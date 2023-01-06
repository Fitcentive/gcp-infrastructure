output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_client_cert" {
  value       = google_container_cluster.primary.master_auth.0.client_certificate
  description = "GKE Cluster Cert"
}

output "kubernetes_client_key" {
  value       = google_container_cluster.primary.master_auth.0.client_key
  description = "GKE Cluster Client key"
  sensitive   = true
}

output "kubernetes_cluster_ca_certificate" {
  value       = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  description = "GKE Cluster CA Certificate"
  sensitive   = true
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "gke_regional_static_ip_name" {
  value       = google_compute_address.regional-static-ip.name
  description = "GKE Regional Static IP name"
}

output "gke_regional_static_ip_address" {
  value       = google_compute_address.regional-static-ip.address
  description = "GKE Regional Static IP address"
}

output "gke_ssl_policy_name" {
  value       = google_compute_ssl_policy.primary-ssl-policy.name
  description = "GKE SSL policy name"
}