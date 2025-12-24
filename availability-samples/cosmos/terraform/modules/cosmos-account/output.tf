output "id"{
  description = "The id of the Cosmos DB account."
  value = azurerm_cosmosdb_account.cosmos.id
}
output "name"{
  description = "The name of the Cosmos DB account."
  value = azurerm_cosmosdb_account.cosmos.name
}

output "endpoint"{
  description = "The endpoint of the Cosmos DB account."
  value = azurerm_cosmosdb_account.cosmos.endpoint
}