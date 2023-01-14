output "service_account_key" {
  value       = google_service_account_key.pubsub-service-account-key.private_key
  description = "Pubsub service account key"
}