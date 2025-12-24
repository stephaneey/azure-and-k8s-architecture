resource "azurerm_service_plan" "plan"{
  name                = var.webappname
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Windows"
    sku_name            = "B1"
}

resource "azurerm_windows_web_app" "webapp" {
  name                = var.webappname
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id = azurerm_service_plan.plan.id

  https_only = true
  identity {
    type = "SystemAssigned"
  }
  site_config {    
    always_on = true    
    ftps_state = "Disabled"    
    default_documents        = ["Default.htm","Default.html","Default.asp","index.htm","index.html","iisstart.html","default.aspx","index.php","hostingstart.html"]
  }

  app_settings = var.app_settings
}