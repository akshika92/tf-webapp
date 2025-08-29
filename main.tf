locals {
  prefix = var.prefix
  rg_name = length(var.resource_group_name) > 0 ? var.resource_group_name : "${local.prefix}-rg"
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

module "networking" {
  source = "./networking"
  prefix = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  vnet_cidr = var.vnet_cidr
  app_subnet_cidr = var.app_subnet_cidr
  pe_subnet_cidr = var.pe_subnet_cidr
}

module "storage" {
  source = "./storage"
  prefix = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  pe_subnet_id = module.networking.pe_subnet_id
}

module "database" {
  source = "./database"
  prefix = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  cosmos_capacity = var.cosmos_capacity
  pe_subnet_id = module.networking.pe_subnet_id
}

module "app" {
  source = "./app"
  prefix = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  app_subnet_id = module.networking.app_subnet_id
  storage_account_id = module.storage.storage_account_id
  cosmos_account_name = module.database.cosmos_account_name
}

module "security" {
  source = "./security"
  prefix = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  webapp_identity = module.app.webapp_identity
  storage_account_id = module.storage.storage_account_id
}
