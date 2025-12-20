resource "azurerm_mssql_failover_group" "fg" {
  name      = var.name
  server_id = var.server_id
  databases = var.databases

  partner_server {
    id = var.partner_server_id
  }
#hardcoding failover policy for demo purposes
  read_write_endpoint_failover_policy {
    mode          = "Manual"    
  }  
}