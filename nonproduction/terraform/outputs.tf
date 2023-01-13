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