resource "azurerm_mssql_database" "db" {
  name                         = var.name
  server_id = var.server_id
  sku_name    = "S1"
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = "200"
  geo_backup_enabled = false
  storage_account_type = "Local"
}

