
terraform {  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.7.0"
    }

  }
}
  provider "azurerm" {
    features {}
    subscription_id="f63a908a-c054-4d45-a1fd-1eadaee67ffc"
  }
variable "cosmosdb" {
  type = string
  default = "db"
}
variable "cosmoscontainer" {
  type = string
  default = "cosmoscontainer"
}

module "cosmos_resource_group" {
  source = "./modules/resource-group"
  resource_group_name     = "cosmos-rg2"
  resource_group_location = "belgiumcentral"  
}

module "belgiumwebsite"{
  source = "./modules/web-app/"
  webappname = local.bewebapp
  resource_group_name = module.cosmos_resource_group.name  
  location = module.cosmos_resource_group.location
  app_settings = {    
    "PreferredRegions" = "BelgiumCentral"
    "EndpointUrl" = module.cosmos_account.endpoint
    "db" = var.cosmosdb
    "container" = var.cosmoscontainer
  }
}

module "francewebsite"{
  source = "./modules/web-app/"
  webappname = local.frwebapp
  resource_group_name = module.cosmos_resource_group.name  
  location = "francecentral"
  app_settings = {    
    "PreferredRegions" = "FranceCentral"
    "EndpointUrl" = module.cosmos_account.endpoint
    "db" = var.cosmosdb
    "container" = var.cosmoscontainer
  }  
}

module "cosmos_account" {
  source = "./modules/cosmos-account" 
  name = local.cosmos
  resource_group_name = module.cosmos_resource_group.name
  location            = module.cosmos_resource_group.location
}


module "cosmos_database" {
  source = "./modules/cosmos-db"  
  name = var.cosmosdb
  resource_group_name = module.cosmos_resource_group.name
  cosmos_account_name = module.cosmos_account.name
  max_throughput = 4000
}

module "cosmos_container" {
  source = "./modules/cosmos-container"  
  name = var.cosmoscontainer
  resource_group_name = module.cosmos_resource_group.name
  cosmos_account_name = module.cosmos_account.name
  cosmos_database_name = module.cosmos_database.name
  max_throughput = 4000
}
resource "azurerm_cosmosdb_sql_role_definition" "cosmosrole" {
  name                = "CosmosDBContributor"
  resource_group_name = module.cosmos_resource_group.name
  account_name        = module.cosmos_account.name
  type                = "CustomRole"
  assignable_scopes   = [module.cosmos_account.id]

  permissions {
    data_actions = [
      "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*",      
      "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*",      
      "Microsoft.DocumentDB/databaseAccounts/readMetadata"]
  }
}

resource "azurerm_cosmosdb_sql_role_assignment" "frenchwebsitetocosmos" {
  name                = "736180af-7fbc-4c7f-9004-22735173c1c3"
  resource_group_name = module.cosmos_resource_group.name
  account_name        = module.cosmos_account.name
  role_definition_id  = "${module.cosmos_account.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = module.francewebsite.identity_principal_id
  scope               = module.cosmos_account.id
}
resource "azurerm_cosmosdb_sql_role_assignment" "belgiumwebsitetocosmos" {
  name                = "a4f3b6e1-5d3e-4c2e-8f12-5f4e3d2c1b0a"
  resource_group_name = module.cosmos_resource_group.name
  account_name        = module.cosmos_account.name
  #role_definition_id  = azurerm_cosmosdb_sql_role_definition.cosmosrole.id
  role_definition_id  = "${module.cosmos_account.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = module.belgiumwebsite.identity_principal_id
  scope               = module.cosmos_account.id
}
resource "azurerm_role_assignment" "cosmos_account_reader_france" { 
  scope = module.cosmos_account.id 
  role_definition_name = "Cosmos DB Account Reader Role"
  principal_id = module.francewebsite.identity_principal_id 
}

resource "azurerm_role_assignment" "cosmos_account_reader_belgium" { 
  scope = module.cosmos_account.id 
  role_definition_name = "Cosmos DB Account Reader Role"
  principal_id = module.belgiumwebsite.identity_principal_id 
}

resource "null_resource" "zip_deploy" {
  provisioner "local-exec" {
    command = "az webapp deployment source config-zip --name ${module.francewebsite.name} --resource-group ${module.cosmos_resource_group.name} --src ./application-code.zip"
  }
  depends_on = [module.francewebsite]
}

resource "null_resource" "zip_deploy-belgium" {
  provisioner "local-exec" {
    command = "az webapp deployment source config-zip --name ${module.belgiumwebsite.name} --resource-group ${module.cosmos_resource_group.name} --src ./application-code.zip"
  }
  depends_on = [module.belgiumwebsite]
}


resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}
locals {
  cosmos = "cosmos-${random_string.suffix.result}"
  bewebapp = "webapp-be-${random_string.suffix.result}"
  frwebapp = "webapp-fr-${random_string.suffix.result}"
  
}