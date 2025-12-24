resource "azurerm_cosmosdb_account" "cosmos" {
  name                      = var.name
  location                  = var.location
  resource_group_name = var.resource_group_name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  automatic_failover_enabled = true
  local_authentication_disabled = false
  multiple_write_locations_enabled = true

  geo_location {
    failover_priority = 0
    location          = var.location
    zone_redundant    = false
  }
  geo_location {
    failover_priority = 1
    location          = "francecentral"
    zone_redundant    = false
  }
  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }  
}