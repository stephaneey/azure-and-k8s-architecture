resource "azurerm_cosmosdb_sql_database" "cosmos" {
  name                = var.name
  resource_group_name = var.resource_group_name
  account_name        = var.cosmos_account_name
  autoscale_settings {
    max_throughput = var.max_throughput
  }
}