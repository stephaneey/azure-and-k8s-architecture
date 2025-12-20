
resource "azurerm_mssql_server" "sql" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  #hardcoded for demo purposes only. Please use a secure method to manage secrets in production
  version                      = "12.0"  
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssw0rd123!"
  public_network_access_enabled = true
}

resource "azurerm_mssql_firewall_rule" "allow_all" {
  name             = "AllowAll"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}