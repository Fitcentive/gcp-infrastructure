output "service_account_key" {
  value       = google_service_account_key.pubsub-service-account-key.private_key
  description = "Pubsub service account key"
}

output "service_account_email_id" {
  value       = google_service_account.pubsub-service-account.email
  description = "Pubsub service account email ID"
}