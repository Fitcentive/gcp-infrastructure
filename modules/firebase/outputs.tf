output "firestore_database_url" {
  value       = data.google_firebase_web_app_config.dev-web-config.database_url
  description = "Firebase firestore database URL"
}
