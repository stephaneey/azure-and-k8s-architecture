
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
    subscription_id="<your-subscription-id>"
  }

module "primary_resource_group" {
  source = "./modules/resource-group"
  resource_group_name     = "primary-sql-rg"
  resource_group_location = "belgiumcentral"  
}

module "secondary_resource_group" {
  source = "./modules/resource-group"
  resource_group_name     = "secondary-sql-rg"
  resource_group_location = "francecentral"  
}

module "primary_server" {
  source = "./modules/sql-server" 
  name = local.sql-primary
  resource_group_name = module.primary_resource_group.name
  location            = module.primary_resource_group.location
}

module "secondary_server" {
  source = "./modules/sql-server" 
  name = local.sql-secondary
  resource_group_name = module.secondary_resource_group.name
  location            = module.secondary_resource_group.location
}

module "primary_database" {
  source = "./modules/sql-database"
  name = "db"
  server_id = module.primary_server.id
}

module "failover_group" {
  source = "./modules/failover-group"
  name = local.failover-group
  server_id = module.primary_server.id
  partner_server_id = module.secondary_server.id
  databases = [module.primary_database.id]
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}
locals {
  sql-primary = "sqlprimary-${random_string.suffix.result}"
  sql-secondary = "sqlsecondary-${random_string.suffix.result}"
  failover-group = "failovergroup-${random_string.suffix.result}"
}