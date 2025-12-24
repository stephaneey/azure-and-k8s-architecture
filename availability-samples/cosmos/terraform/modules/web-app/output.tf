output "id" {
  description = "The id of the webapp."
  value       = azurerm_windows_web_app.webapp.id
}
output "name" {
  description = "The name of the webapp."
  value       = azurerm_windows_web_app.webapp.name
}

output "identity_principal_id" {
  description = "The principal id of the webapp's system assigned identity."
  value       = azurerm_windows_web_app.webapp.identity[0].principal_id
}