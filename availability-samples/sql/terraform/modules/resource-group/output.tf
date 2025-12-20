output "location" {
  description = "The location of the resource group."
  value       = azurerm_resource_group.rg.location
}

output "name" {
  description = "The name for the resource group."
  value       = azurerm_resource_group.rg.name
}

output "id"{
  description = "The id of the resource group."
  value = azurerm_resource_group.rg.id
}