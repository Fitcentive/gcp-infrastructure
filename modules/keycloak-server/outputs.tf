output "keycloak_admin_client_password" {
  value       = random_password.keycloak-admin-pwd.result
  description = "Keycloak admin client password"
}