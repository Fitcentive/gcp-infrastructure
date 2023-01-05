output "service_account_key" {
  value       = google_service_account_key.terraform-service-account-key.private_key
  description = "Terraform service account key"
}