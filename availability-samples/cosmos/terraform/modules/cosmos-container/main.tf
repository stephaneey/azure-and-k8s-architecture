resource "azurerm_cosmosdb_sql_container" "container" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  account_name          = var.cosmos_account_name
  database_name         = var.cosmos_database_name
  partition_key_paths    = ["/id"]
  partition_key_version = 1
  autoscale_settings {
    max_throughput = var.max_throughput
  }
  
  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}